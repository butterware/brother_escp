require 'chunky_png'
require 'logger'
require 'brother_escp/image_converter'

class BrotherEscp::Image
  
  attr_reader :image
  attr_reader :converter
  
  def initialize(file_name:, converter: :single_density)
    load(file_name: file_name)
    
    load_converter(converter)
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
    @lines = converter.convert(image: image)
    self
  end
  
  def to_escp
    @lines.map { |line| convert_line_to_escp(line) }.join
  end
  
  private
  
  def load_converter(converter)
    @converter = case converter
    when :single_density
      BrotherEscp::ImageConverter.new(density_code: 0, line_height_in_bytes: 1)
    when :high_density
      BrotherEscp::ImageConverter.new(density_code: 39, line_height_in_bytes: 3)
    when :higher_density
      BrotherEscp::ImageConverter.new(density_code: 72, line_height_in_bytes: 6)
    else
      msg = "Unknown converter (#{converter})"
      logger.fatal msg
      raise msg
    end
  end
  
  def convert_line_to_escp(line)
    converter.convert_line_to_escp(line: line) + BrotherEscp::Sequence.crlf
  end
  
  def logger
    BrotherEscp.logger
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