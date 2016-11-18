# frozen_string_literal: true
module BrotherEscp
  # This module take care of the commands and various esc sequences to send meta data to the printer
  module Sequence
    module_function

    # predefined sequence of commands for the printer
    SEQUENCES = {

      # Printer hardware
      HW_INIT:                  [0x1b, 0x40], # Clear data in buffer and reset modes
      HW_SET_ESCP_MODE:         [0x1B, 0x69, 0x61, 0x00], # Sets the command mode to ESC/P

      # Select landscape orientation
      LANDSCAPE_ON:             [0x1b, 0x69, 0x4c, 1],
      LANDSCAPE_OFF:            [0x1b, 0x69, 0x4c, 0],

      # Line feed commands
      LINE_FEED:                [0x1b, 0x33],

      # Specify page length
      PAGE_LENGTH:              [0x1b, 0x28, 0x43, 2, 0],

      # Feed control sequences
      CTL_LF:                   [0x0a],                               # Print and line feed
      CTL_FF:                   [0x0c],                               # Form feed
      CTL_CR:                   [0x0d],                               # Carriage return
      CTL_HT:                   [0x09],                               # Horizontal tab
      CTL_VT:                   [0x0b],                               # Vertical tab
    }.freeze

    # Format a sequence to the raw data needed by the printer
    # @param value [Symbol, Integer, Array] Symbol will take the references from the {SEQUENCES}, Integer or Array will be packed as a simple ASCII string
    def sequence(value)
      val = value.is_a?(Symbol) ? SEQUENCES[value] : value

      Array(val).pack('C*')
    end

    # helper method to issue a carriage return / line feed sequence (go to the next line)
    def crlf
      sequence [0x0d, 0x0a]
    end

    # Helper method to set the line feed size
    # @param n [Integer] line feed size in dots
    def line_feed_size(n)
      sequence(:LINE_FEED) + sequence(n)
    end

    # Helper method to set the page length
    # @param n [Integer] page length size in dots
    def page_length(n)
      sequence(:PAGE_LENGTH) + sequence([n % 256, n / 256])
    end
  end
end
