# frozen_string_literal: true
require 'base64'
require 'logger'
require 'brother_escp/version'
require 'brother_escp/document'
require 'brother_escp/image'
require 'brother_escp/sequence'

# Main module
module BrotherEscp
  module_function

  # Helper method to access logger
  def logger
    @logger ||= Logger.new(STDERR)
  end
end
