require 'chunky_png'
require 'logger'

class BrotherEscp::Image
  
  attr_reader :image
  
  def initialize(file_name:)
    load(file_name: file_name)
  end
  
  def inspect
    puts "height    : #{@image.height}"
    puts "width     : #{@image.width}"
    puts "metadata  : #{@image.metadata}"
    if @lines
      @lines.each_with_index do |e, i|
        puts "#{i}: #{e.inspect}"
      end
    end
  end
  
  def convert
    @lines = []
    if (remain = height % 8) > 0
      logger.warn "the height (#{height}) is not a multiple if 8, the last #{remain} lines will be ignored."
    end
    0.upto((height / 8) - 1) do |line_index|
      line = []
      0.upto(width - 1) do |x|
        bits = ''
        0.upto(7) do |y_offset|
          y = (line_index * 8) + y_offset
          bits << convert_pixel_to_bw(@image[x,y])
        end
        line << bits.to_i(2)
      end
      @lines << line
    end
    self
  end
  
  def to_escp
    @lines.map { |line| convert_line_to_escp(line) }.join(BrotherEscp::Sequence.crlf)
  end
  
  private
  
  def convert_line_to_escp(line)
    n1 = line.length % 256
    n2 = line.length / 256
    data = [ 0x1b, 0x2a, 0, n1, n2 ]
    data += line
    data.pack('C*')
  end
  
  def convert_pixel_to_bw(pixel)
    r, g, b, a =
      ChunkyPNG::Color.r(pixel),
      ChunkyPNG::Color.g(pixel),
      ChunkyPNG::Color.b(pixel),
      ChunkyPNG::Color.a(pixel)
    px = (r + g + b) / 3

    logger.warn "PNG images with alpha are not supported." unless a == 255

    px > 128 ? '0' : '1'
  end
  
  def logger
    @logger ||= Logger.new(STDERR)
  end

  def load(file_name:)
    @image = ChunkyPNG::Image.from_file(file_name)
  end
    
  def height
    @image.height
  end
  
  def width
    @image.width
  end
  
end