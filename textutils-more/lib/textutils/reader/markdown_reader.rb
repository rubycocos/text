# encoding: utf-8


#######################################################
############# work in progress  #######################
#
#  NOTE: do NOT include for now in packaged gem

#######
## read data records "encoded" in markdown / plain text
###

class MarkdownReader

  include LogUtils::Logging

  def self.from_file( path )
    text = 'to be done'
    self.from_string( text )
  end
  
  def self.from_string( text )
    MarkdownReader.new( text )
  end

  def initialize( path, more_attribs={} )
    @more_attribs = more_attribs
    @text         = text
    ## to be done
  end

  ## to be done

end # class MarkdownReader

