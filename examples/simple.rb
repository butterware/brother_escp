require 'brother_escp'

doc = BrotherEscp::Document.new

doc.sequence(:HW_INIT)
doc.sequence(:HW_SET_ESCP_MODE)
doc.sequence(:LINE_FEED_8)

doc.image(file_name: 'examples/small.png')

doc.sequence(:CTL_FF)

# puts doc.to_escp
puts
puts doc.inspect
puts
puts doc.to_base64
