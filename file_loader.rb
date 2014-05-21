class HTMLCleanup
  attr_accessor :file
  def initialize file
    @file = file
  end

  def load
    File.read(@file).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  end

  def pdf_cleanup regexes
    ##requirements
    if regexes.is_a?(Hash)
      regexes.each do |regex, replace|
        if (regex.is_a?(Regexp))

        else
          raise ArgumentError, "non regular expression in hash"
        end

      end
    else
      raise ArgumentError, "Not a Hash"
    end
  end

end

