# frozen_string_literal: true
require 'spec_helper'

describe BrotherEscp::Document do
  it 'Accept sequences and translate them' do
    doc = BrotherEscp::Document.new
    doc.line_feed_size = 8
    doc.sequence(:CTL_FF)

    expect(doc.to_base64).to eql('G2lhABtAGzMIDA==')
  end
end
