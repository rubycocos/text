# encoding: utf-8

module TextUtils
  module XmlHelper


  def prettify_xml( xml )
    require 'rexml/document'
    
    begin
      d = REXML::Document.new( xml )
    
      # d.write( pretty_xml="", 2 )
      # pretty_xml  # return prettified xml
    
      formatter = REXML::Formatters::Pretty.new( 2 )  # indent=2
      formatter.compact = true # This is the magic line that does what you need!
      pretty_xml = formatter.write( d.root, "" )  # todo/checl: what's 2nd arg used for ??
      pretty_xml
    rescue Exception => ex
      "warn: prettify_xml failed: #{ex}\n\n\n" + xml
    end
  end


  end # module XmlHelper
end # module TextUtils
