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

    it "throws an ArgumentError when given fewere than 1 parameters" do
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
      lambda { @htmlcleanup.pdf_cleanup("testing") }.should raise_error("Not a Hash")
    end
    it "requires regular expressions in the hash" do
      lambda { @htmlcleanup.pdf_cleanup({ 1 => "hello" }) }.should raise_error("non regular expression in hash")
    end
    it "requires replacement string in the hash" do
      lambda { @htmlcleanup.pdf_cleanup({ /\d/ => 1 }) }.should raise_error("non string in replacemet position in hash")
    end
    it "changes the file string with the regexes" do
      regexes = {
		/<p[\s\n]+>/i => "<p>",
                /  remove\sme\n/i => ""
        }
      @htmlcleanup.load
      @htmlcleanup.pdf_cleanup(regexes)
      @htmlcleanup.loaded_file.should eql HTMLCleanup.new("correct_edits.html").load
    end
  end

  describe "#disclaimer" do
    it "should ask for a UID if it can't figure one out" do
      STDOUT.should_receive(:puts).with("Which Collection should we use for the disclaimer link?")
      @htmlcleanup.disclaimer
    end
  end
end
