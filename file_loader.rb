class HTMLCleanup
  attr_accessor :file, :loaded_file
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
    regexes.each do | regex, replace |
        @loaded_file.gsub!(regex, replace)
    end
  end
  def disclaimer
	#uid = gets.chomp
        doc = @file.to_s.sub(/\.html?/, '').downcase

        #find the uid by the file name
        collection_identifiyer = doc.sub(/r\d+/i, '')

        case collection_identifiyer
          when "cp"
            collection = "mre_pm_100_04"
          when "pi"
            collection = "mr_pm_100_08"
          when "otn"
            collection = "mre_pm_100_20"
          when "bp"
            collection = "mre_pm_100_02"
          when "soma"
            collection = "mre_pm_100_07"
          when "demo"
            collection = "mre_mr_pm_100_19"
          when "msp"
            collection = "mre_mr_mspm"
          when "ncd"
            collection = "mre_pm_100_03"
          when "gi"
            collection = "mr_pm_100_01"
          when "fm"
            collection = "mr_pm_100_6"
          else
            puts "Which Collection should we use for the disclaimer link?"
            collection = gets.chomp
        end

        uid = collection.gsub(/_/, '').downcase + doc

	regex = /(\(Rev.\s?\d+,.*<\/p>)/i

	replace = "\\1\n</b><font color=\"#000000\"><p><i>Note:</i> Minor inconsistencies may occur during PDF conversion process. You can also view this document <!!uf #{collection} #{uid}>in PDF.</a></p></font>"

	@loaded_file.gsub!(regex, replace)
  end

  def save

  end

end
