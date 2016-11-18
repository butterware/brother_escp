# frozen_string_literal: true
require 'base64'
require 'brother_escp/version'
require 'brother_escp/image'
require 'brother_escp/sequence'

module BrotherEscp
  # Main class to manage document
  # Instanciate one for each printing
  class Document
    # @param log_level set log level, default to info
    def initialize(log_level: Logger::INFO)
      @data = String.new('')
      sequence(:HW_SET_ESCP_MODE)
      sequence(:HW_INIT)

      BrotherEscp.logger.level = log_level
    end

    # Write data to the document
    # @param data [String] raw data to send to the printer
    def write(data)
      @data << data
    end

    # Add an image to the document
    # This will only work for PNG files, the alpha layer will be ignored
    # @param file_name [String] file name of the image file
    # @param density [Symbol] set the image density, default to single_density, possible values are: :single_density, :high_density, :higher_density
    def image(file_name:, density: :single_density)
      img = BrotherEscp::Image.new(file_name: file_name, converter: density)
      write(img.convert.to_escp)
    end

    # Add a pre-defined sequence to the document
    # @see BrotherEscp::Sequence#sequence
    def sequence(value)
      write(BrotherEscp::Sequence.sequence(value))
    end

    # Helper method to set the line feed size
    # @param n [Integer] line feed size in dots
    def line_feed_size=(n)
      write(BrotherEscp::Sequence.line_feed_size(n))
    end

    # Helper method to set the page length
    # @param n [Integer] page length size in dots
    def page_length=(n)
      write(BrotherEscp::Sequence.page_length(n))
    end

    # Inspect the data
    # @return [String] the hexadecimal string representation of the data
    def inspect
      to_escp.chars.map { |c| "0x#{c.unpack('H*').first}" }.join(' ')
    end

    # Return the raw data
    # @return [String] the raw data
    def to_escp
      @data
    end

    # Return base64 encoded data
    # @return [String] the base64 encoded data
    def to_base64
      Base64.strict_encode64 to_escp
    end
  end
end
