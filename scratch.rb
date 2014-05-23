
class HTMLCleanup
  attr_accessor :file
  def initialize file
    @file = file
  end

  def load
    @loaded_file = File.read(@file).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  end

  def pdf_cleanup regexes
    ##requirements
    if regexes.is_a?(Hash)
      regexes.each do |regex, replace|
        if (!regex.is_a?(Regexp))
          raise ArgumentError, "non regular expression in hash"
        elsif (!replace.is_a?(String))
          raise ArgumentError, "non string in replacemet position in hash"
        end
      end
    else
      raise ArgumentError, "Not a Hash"
    end
    puts "regexes length #{regexes.length.to_s}"
    puts regexes
    regexes.each do | regex, replace |
        @loaded_file.gsub!(regex, replace)
        puts "hello"
        return @loaded_file
    end
  end

end
 htmlcleanup = HTMLCleanup.new("test.html")
 puts "load"
 puts htmlcleanup.load
 puts "cleaning"
       regexes = {
 		/<p[\s\n]+>/i => "<p>",
                /remove\sme/i => ""
         }
 puts htmlcleanup.pdf_cleanup(regexes)
