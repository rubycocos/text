

####
## move to csvutils ??? why? why not?
##

#######
## read data records in csv (comma-separated values) format in plain text


class TableReader    ## rename to CsvTableReader ? or CsvReader?

  include LogUtils::Logging

  def initialize( path, opts={} )
    @opts = opts
    @path = path
    ## to be done
  end

  def quick_check
    # use a quick scan of all rows (return some stats e.g. no of records)
    #  - throws an exception if any error

    ## to be done
  end

  ## to be done

end # class MarkdownReader

