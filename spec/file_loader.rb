require 'spec_helper'

describe HTMLCleanup do
  file = "R1CP.html"
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
      @htmlcleanup.file.should eql "R1CP.html"
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
      @htmlcleanup.loaded_file.should eql HTMLCleanup.new("correct_replacements.html").load
    end
  end

  describe "#disclaimer" do
    it "should ask for a UID if it can't figure one out" do
      @no_uid = HTMLCleanup.new "no_uid.html"
      STDOUT.should_receive(:puts).with("Which Collection should we use for the disclaimer link?")
      @no_uid.load
      @no_uid.disclaimer
    end
    it "should remove the file extension and downcase filename for html/htm files" do
      @htmlcleanup.load
      @htmlcleanup.disclaimer
      @htmlcleanup.doc.should eql "r1cp"
    end
    it "should add the disclaimer to the file if it finds the Rev." do
      @htmlcleanup.load
      @htmlcleanup.disclaimer
      #match for the disclaimer
      #check the match being greater than one
      matches = @htmlcleanup.loaded_file.match(/Minor inconsistencies may occur during PDF conversion process\. You can also view this document <!!uf/).length.to_i
      matches.should be > 0
    end
  end
  describe "#save" do
    it "should use the correct file name for the save" do
      @htmlcleanup.load
      @htmlcleanup.disclaimer
      @htmlcleanup.save
      @htmlcleanup.file_name.should eql "edited_R1CP.html"
    end
    it "should write the changes to the new file name" do
      regexes = {
		/<p[\s\n]+>/i => "<p>",
                /  remove\sme\n/i => ""
        }
      @htmlcleanup.load
      @htmlcleanup.pdf_cleanup(regexes)
      @htmlcleanup.disclaimer
      @htmlcleanup.save
     File.read(@htmlcleanup.file_name).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').should eql File.read("correct_edits.html").encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')

    end
  end
end
