# encoding: utf-8

module TextUtils
  module TagHelper


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

  def find_tags_in_hash!( h )
    # NB: will remove :tags from hash

    if h[:tags].present?
      tag_keys = find_tags( h[:tags] )
      h.delete(:tags)
      tag_keys   # return tag keys as ary
    else
      []  # nothing found; return empty ary
    end
  end

  end # module TagHelper
end # module TextUtils
