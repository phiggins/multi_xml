require 'helper'
require 'parser_shared_example'

class MockDecoder; end

describe "MultiXml" do
  context "Parsers" do
    it "should default to the best available gem" do
      pending
      MultiXml.parser.name.should == 'MultiXml::Parsers::Rexml'
      require 'nokogiri'
      MultiXml.parser.name.should == 'MultiXml::Parsers::Nokogiri'
      require 'libxml'
      MultiXml.parser.name.should == 'MultiXml::Parsers::Libxml'
    end

    it "should be settable via a symbol" do
      MultiXml.parser = :nokogiri
      MultiXml.parser.name.should == 'MultiXml::Parsers::Nokogiri'
    end

    it "should be settable via a class" do
      MultiXml.parser = MockDecoder
      MultiXml.parser.name.should == 'MockDecoder'
    end
  end

  [['LibXML', 'libxml'],
   ['REXML', 'rexml/document'],
   ['Nokogiri', 'nokogiri']].each do |parser|
    begin
      require parser.last
      context "#{parser.first} parser" do
        it_should_behave_like "a parser", parser.first
      end
    rescue LoadError => e
      puts "Tests not run for #{parser.first} due to a LoadError"
    end
  end
end
