require 'base64'
require "brother_escp/version"
require 'brother_escp/image'
require 'brother_escp/sequence'

module BrotherEscp
  
  class Document
    
    def initialize
      @data = ""
    end
    
    def write(data)
      @data << data
    end
    
    def image(file_name:)
      img = BrotherEscp::Image.new(file_name: file_name)
      write(img.convert.to_escp)
    end
    
    def sequence(value)
      write(BrotherEscp::Sequence.sequence(value))
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
