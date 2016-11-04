module BrotherEscp

  class ImageConverter
    
    attr_reader :density_code
    attr_reader :line_height_in_bytes
    attr_reader :line_height_in_pixels
    
    def initialize(density_code: 0, line_height_in_bytes: 1)
      @density_code = density_code
      @line_height_in_bytes = line_height_in_bytes
      @line_height_in_pixels = line_height_in_bytes * 8
    end

    def convert(image:)
      lines = []
      if (remain = image.height % line_height_in_pixels) > 0
        BrotherEscp.logger.warn "the height (#{image.height}) is not a multiple if #{line_height_in_pixels}, the last #{remain} lines will be ignored."
      end
      line_count = (image.height / line_height_in_pixels)
      BrotherEscp.logger.debug "convert, line_count = #{line_count}"
      0.upto(line_count - 1) do |line_index|
        line = []
        0.upto(image.width - 1) do |x|
          0.upto(line_height_in_bytes - 1) do |byte_offset|
            bits = ''
            0.upto(7) do |y_offset|
              y = (line_index * line_height_in_pixels) + (byte_offset * 8) + y_offset
              bit = convert_pixel_to_bw(image[x,y])
              # BrotherEscp.logger.debug "convert, line = #{line_index}, byte_offset = #{byte_offset}, x = #{x}, y = #{y}, bit: #{bit}"
              bits << bit
            end
            line << bits.to_i(2)
          end
        end
        lines << line
      end
      lines
    end
    
    def convert_line_to_escp(line:)
      n1 = line.length / line_height_in_bytes % 256
      n2 = line.length / line_height_in_bytes / 256
      BrotherEscp.logger.debug "convert_line_to_escp, length = #{line.length}, n1 = #{n1}, n2 = #{n2}"
      data = [ 0x1b, 0x2a, density_code, n1, n2 ]
      data += line
      data.pack('C*')
    end
    
    private
    
    def convert_pixel_to_bw(pixel)
      r, g, b, a =
        ChunkyPNG::Color.r(pixel),
        ChunkyPNG::Color.g(pixel),
        ChunkyPNG::Color.b(pixel),
        ChunkyPNG::Color.a(pixel)
      px = (r + g + b) / 3
      # BrotherEscp.logger.debug "convert_pixel_to_bw: #{[r, g, b, a]}, px = #{px}"
      BrotherEscp.logger.warn "PNG images with alpha are not supported." unless a == 255

      px > 128 ? '0' : '1'
    end

  end

end