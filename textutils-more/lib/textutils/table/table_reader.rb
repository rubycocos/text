# encoding: utf-8


#######################################################
############# work in progress  #######################
#
#  NOTE: do NOT include for now in packaged gem


####
## move to csvutils ??? why? why not?
##

#######
## read data records in csv (comma-separated values) format in plain text


class TableReader    ## rename to CsvTableReader ? or CsvReader?

  include LogUtils::Logging

  def self.from_file( path )
    text = 'to be done'
    self.from_string( text )
  end
  
  def self.from_string( text )
    TableReader.new( text )
  end

  def initialize( text, opts={} )
    @opts = opts
    @text = text
    ## to be done
  end

  def quick_check
    # use a quick scan of all rows (return some stats e.g. no of records)
    #  - throws an exception if any error

    ## to be done
  end

  ## to be done

end # class TableReader

