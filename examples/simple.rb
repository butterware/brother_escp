require 'brother_escp'

doc = BrotherEscp::Document.new

doc.sequence(:HW_SET_ESCP_MODE)
doc.sequence(:HW_INIT)
doc.sequence(:LANDSCAPE_OFF)

doc.image(file_name: 'examples/small.png')
doc.image(file_name: 'examples/small.png', density: :high_density)
doc.image(file_name: 'examples/small.png', density: :higher_density)

doc.sequence(:CTL_FF)

# puts doc.to_escp
puts
puts doc.inspect
puts
puts doc.to_base64
