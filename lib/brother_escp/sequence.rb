module BrotherEscp::Sequence

  SEQUENCES = {

    # Printer hardware
    HW_INIT:                  [ 0x1b, 0x40 ],                         # Clear data in buffer and reset modes
    HW_SET_ESCP_MODE:         [ 0x1B, 0x69, 0x61, 0x00],              # Sets the command mode to ESC/P

    # Select landscape orientation
    LANDSCAPE_ON:             [ 0x1b, 0x69, 0x4c, 1 ],
    LANDSCAPE_OFF:            [ 0x1b, 0x69, 0x4c, 0 ],

    # Line feed commands
    LINE_FEED:                [ 0x1b, 0x33 ],
    
    # Specify page length
    PAGE_LENGTH:              [ 0x1b, 0x28, 0x43, 2, 0 ],

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
  
  def set_line_feed_size(n)
    sequence(:LINE_FEED) + sequence(n)
  end
  
  def set_page_length(n)
    sequence(:PAGE_LENGTH) + sequence([n % 256, n / 256])
  end
  
  extend self
  
end