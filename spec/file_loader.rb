require 'spec_helper'

describe HTMLCleanup do
  file = "test.html"
  bad_regexes = {
    1 => "hello"
  }
  bad_strings = {
    /\d/ => 1
  }

  before :each do
    @htmlcleanup = HTMLCleanup.new file
  end

  describe "#new" do
    it "returns a new HTMLCleanup object" do
      @htmlcleanup.should be_an_instance_of HTMLCleanup
    end

    it "throws an ArgumentError when given fewere than 3 parameters" do
      lambda { HTMLCleanup.new }.should raise_exception ArgumentError
    end
  end

  describe "#file" do
    it "returns the correct file name" do
      @htmlcleanup.file.should eql "test.html"
    end
  end

  describe "#load" do
    it "returns load the correct file " do
      @htmlcleanup.load.should eql File.read(file).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end
  end

  describe "#pdf_cleanup" do
    it "requires a hash" do
      lambda { HTMLCleanup.new.pdf_cleanup("testing") }.should raise_exception ArgumentError
    end
    it "requires regular expressions in the hash" do
      bad_regexes.each do |regex, replace|
        lambda { HTMLCleanup.new.pdf_cleanup(bad_regexes) }.should raise_exeption Argument Error
      end
    end
  end
end
