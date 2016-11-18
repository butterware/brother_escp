# frozen_string_literal: true
require 'chunky_png'
require 'logger'
require 'brother_escp/image_converter'

module BrotherEscp
  # Main classe to manipulate images
  class Image
    attr_reader :image
    attr_reader :converter

    # @param file_name file name of the image to load
    # @param converter [Symbol] set the image density, default to single_density, possible values are: :single_density, :high_density, :higher_density
    def initialize(file_name:, converter: :single_density)
      load(file_name: file_name)

      load_converter(converter)
    end

    # Print some meta data to current image
    def inspect
      puts "height    : #{@image.height}"
      puts "width     : #{@image.width}"
      puts "metadata  : #{@image.metadata}"
      @lines&.each_with_index do |e, i|
        puts "#{i}: #{e.inspect}"
      end
    end

    # Run the convert process. Create internally an array of lines
    # @return self
    def convert
      @lines = converter.convert(image: image)
      self
    end

    # Give the image data converted to the printer format
    def to_escp
      @lines.map { |line| convert_line_to_escp(line) }.join
    end

    private

    def load_converter(converter)
      @converter = BrotherEscp::ImageConverter.converter(density: converter)
    end

    def convert_line_to_escp(line)
      converter.convert_line_to_escp(line: line) + BrotherEscp::Sequence.crlf
    end

    def load(file_name:)
      @image = ChunkyPNG::Image.from_file(file_name)
    end
  end
end
