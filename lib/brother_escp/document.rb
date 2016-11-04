require 'base64'
require "brother_escp/version"
require 'brother_escp/image'
require 'brother_escp/sequence'

module BrotherEscp
  
  class Document
    
    def initialize(log_level: Logger::INFO)
      @data = ""
      BrotherEscp::logger.level = log_level
    end
    
    def write(data)
      @data << data
    end
    
    def image(file_name:, density: :single_density)
      img = BrotherEscp::Image.new(file_name: file_name, converter: density)
      write(img.convert.to_escp)
    end
    
    def sequence(value)
      write(BrotherEscp::Sequence.sequence(value))
    end
    
    def set_line_feed_size(n)
      write(BrotherEscp::Sequence.set_line_feed_size(n))
    end
    
    def set_page_length(n)
      write(BrotherEscp::Sequence.set_page_length(n))
    end
    
    def inspect
      to_escp.chars.map{ |c| "0x#{c.unpack('H*').first}" }.join(' ')
    end
    
    def to_escp
      @data
    end
    
    def to_base64
      Base64.strict_encode64 to_escp
    end
    
  end
  
end
