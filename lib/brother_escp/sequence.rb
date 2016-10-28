module BrotherEscp::Sequence

  SEQUENCES = {

    # Printer hardware
    HW_INIT:                  [ 0x1b, 0x40 ],                         # Clear data in buffer and reset modes
    HW_SET_ESCP_MODE:         [ 0x1B, 0x69, 0x61, 0x00],              # Sets the command mode to ESC/P

    # Line feed commands
    LINE_FEED_8:              [ 0x1b, 0x33, 8 ],
    LINE_FEED_24:             [ 0x1b, 0x33, 24 ],

    # Feed control sequences
    CTL_LF:                   [ 0x0a ],                               # Print and line feed
    CTL_FF:                   [ 0x0c ],                               # Form feed
    CTL_CR:                   [ 0x0d ],                               # Carriage return
    CTL_HT:                   [ 0x09 ],                               # Horizontal tab
    CTL_VT:                   [ 0x0b ],                               # Vertical tab
  }

  def sequence(value)
    val = value.kind_of?(Symbol) ? SEQUENCES[value] : value
      
    Array(val).pack('C*')
  end

  def crlf
    sequence [ 0x0d, 0x0a ]
  end
  
  extend self
  
end