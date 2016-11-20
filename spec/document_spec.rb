# frozen_string_literal: true
require 'spec_helper'

describe BrotherEscp::Document do
  it 'is inspectable' do
    doc = BrotherEscp::Document.new
    expect(doc.inspect).to_not be_empty
  end

  it 'Accept sequences and translate them' do
    doc = BrotherEscp::Document.new
    doc.line_feed_size = 8
    doc.sequence(:CTL_FF)
    doc.page_length = 50
    expect(doc.to_base64).to eql('G2lhABtAGzMIDBsoQwIAMgA=')
  end

  it 'Accept images and translate them' do
    doc = BrotherEscp::Document.new
    doc.image(file_name: File.join(__dir__, 'fixtures/small.png'))
    expect(doc.to_base64).to eql('G2lhABtAGyoAZAD/gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID/DQobKgBkAP8AAAAAAH8DAgICAgJ/AAABBwwICAwHAQB/fwAAfwAAAwYMCAgMBwAAAAAAAAAAAAAAAEB/f0AAAA8EDAgMBwQMCAwHAAAADAgJDQcDAAEHDAgIDA8AAAMHDAgIDAcAAAAAAP8NChsqAGQA/wAAAAAA+AAAAAAAAPgAAODwmIiIiJiAAPj4AAD4AADgeAgICBjwgAAPHBAAAAAAAAAACPj4CAAA+AAAAAD4AAAAAPgAAHDYiIgY+PgA4PEZGRkT/gAA4PCYiIiImAAAAAAA/w0KGyoAZAD/AAAAAAAAAAAAAAAAAAAAAAEPDA8BAAAAAAEAAQEBAAAAAAABAQEBDwAAAAAAAAgPAQAAAA8OAwAAAAcOAAAAAQEBAQAAAAABAAEBAAAAAQEBDw8AAAAAAAAAAAAAAAAAAAD/DQobKgBkAP8AAAAAAAAAAAAAAAAAAAc++JgYmPg+BwD//4CAAID/AAB+54EBAYP/AAAAAAAAAID4Hw/4gADwPwd+4AAAfP6DAQGD/nwA//+AgIAQ/sOBAYP//wAAAAAAAAAAAAAAAAAAAP8NChsqAGQA/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/w0K')
  end
end
