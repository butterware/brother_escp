# frozen_string_literal: true
module BrotherEscp
  # Image conversion logic
  class ImageConverter
    # printer parameters for each supported density
    CONVERTER_PARAMS = {
      single_density: { density_code: 0,   line_height_in_bytes: 1 },
      high_density:   { density_code: 39,  line_height_in_bytes: 3 },
      higher_density: { density_code: 72,  line_height_in_bytes: 6 }
    }.freeze

    # Create a new instance of an image
    # @param density [Symbol] set the image density, default to single_density, possible values are: :single_density, :high_density, :higher_density
    # @return [BrotherEscp::ImageConverter] instance
    def self.converter(density: :single_density)
      params = CONVERTER_PARAMS[density]
      raise "Unknown converter (#{density})" unless params
      new(density_code: params[:density_code], line_height_in_bytes: params[:line_height_in_bytes])
    end

    attr_reader :density_code
    attr_reader :line_height_in_bytes
    attr_reader :line_height_in_pixels

    # @param density_code [Integer] density code
    # @param line_height_in_bytes [Integer] number of bytes by line
    def initialize(density_code: 0, line_height_in_bytes: 1)
      @density_code = density_code
      @line_height_in_bytes = line_height_in_bytes
      @line_height_in_pixels = line_height_in_bytes * 8
    end

    # Main conversion method from image data to printer bitmap format
    # @param image [ChunkyPNG::Image] Image to convert
    # @return [Array] return an array of array, one array for each line, with one element for each byte
    def convert(image:)
      check_image(image: image)
      lines = []
      line_count = (image.height / line_height_in_pixels)
      # BrotherEscp.logger.debug "convert, line_count = #{line_count}"
      0.upto(line_count - 1) do |line_index|
        lines << create_line(image: image, line_index: line_index)
      end
      lines
    end

    # Convert a line array to a raw data
    # @param line [Array] Array of bytes representing one line
    def convert_line_to_escp(line:)
      n1 = line.length / line_height_in_bytes % 256
      n2 = line.length / line_height_in_bytes / 256
      BrotherEscp.logger.debug "convert_line_to_escp, length = #{line.length}, n1 = #{n1}, n2 = #{n2}"
      data = [0x1b, 0x2a, density_code, n1, n2]
      data += line
      data.pack('C*')
    end

    private

    def check_image(image:)
      remain = image.height % line_height_in_pixels
      BrotherEscp.logger.warn { "the height (#{image.height}) is not a multiple if #{line_height_in_pixels}, the last #{remain} lines will be ignored." } if remain.positive?
    end

    def create_line(image:, line_index:)
      line = []
      0.upto(image.width - 1) do |x|
        0.upto(line_height_in_bytes - 1) do |byte_offset|
          line << create_bits(image: image, line_index: line_index, x: x, byte_offset: byte_offset)
        end
      end
      line
    end

    def create_bits(image:, line_index:, x:, byte_offset:)
      bits = String.new('')
      0.upto(7) do |y_offset|
        y = (line_index * line_height_in_pixels) + (byte_offset * 8) + y_offset
        bit = convert_pixel_to_bw(image[x, y])
        # BrotherEscp.logger.debug "convert, line = #{line_index}, byte_offset = #{byte_offset}, x = #{x}, y = #{y}, bit: #{bit}"
        bits << bit
      end
      bits.to_i(2)
    end

    def convert_pixel_to_bw(pixel)
      r = ChunkyPNG::Color.r(pixel)
      g = ChunkyPNG::Color.g(pixel)
      b = ChunkyPNG::Color.b(pixel)
      a = ChunkyPNG::Color.a(pixel)
      px = (r + g + b) / 3
      # BrotherEscp.logger.debug "convert_pixel_to_bw: #{[r, g, b, a]}, px = #{px}"
      BrotherEscp.logger.warn 'PNG images with alpha are not supported.' unless a == 255

      px > 128 ? '0' : '1'
    end
  end
end
