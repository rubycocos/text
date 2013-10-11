# encoding: utf-8

module TextUtils
  module TagHelper

####
# - todo: use new additional sub module ???
#     e.g. TextUtils::Reader::TagHelper
#   lets us use "classic" web helpers a la rails
#   find a good name for sub module -  Reader? Fixtures? Values? Parser? 


  def find_tags( value )
    # logger.debug "   found tags: >>#{value}<<"

    tag_keys = value.split('|')

    ## unify; replace _w/ space; remove leading n trailing whitespace
    tag_keys = tag_keys.map do |key|
      key = key.gsub( '_', ' ' )
      key = key.strip
      key
    end

    tag_keys # return tag keys as ary
  end

  def find_tags_in_attribs!( attribs )
    # NB: will remove :tags from attribs hash

    if attribs[:tags].present?
      tag_keys = find_tags( attribs[:tags] )
      attribs.delete(:tags)
      tag_keys   # return tag keys as ary of strings
    else
      []  # nothing found; return empty ary
    end
  end

  end # module TagHelper
end # module TextUtils
