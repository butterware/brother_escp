require 'base64'
require 'logger'
require "brother_escp/version"
require "brother_escp/document"
require 'brother_escp/image'
require 'brother_escp/sequence'

module BrotherEscp
  
  def logger
    @logger ||= Logger.new(STDERR)
  end
  
  extend self
  
end
