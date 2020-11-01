# encoding: utf-8

module Linkto
  module FlickrHelper


#####################
#  browse tags 

  def link_to_flickr_tags( tags, opts={} )   # fix: add alias for link_to_flickr_tag
    # e.g. use
    #  ottakringer
    #  ottakringer+beer    -- use plus for multiple tags
    link_to tags, "http://www.flickr.com/photos/tags/#{tags}", opts
  end

#########################
#  search terms (q)

  def link_to_flickr_search( q, opts={} )
     # e.g. use
     #   ottakringer
     #   ottakringer+beer    -- note: + is url encoded for space e.g. equals ottakringer beer
    link_to q, "http://www.flickr.com/search/?q=#{q}", opts
  end

###############################
# shortcuts / aliases

  def flickr_tags( tags, opts={} ) link_to_flickr_tags( tags, opts ) end
  def flickr_search( q, opts={} )  link_to_flickr_search( q, opts )  end


  end # module FlickrHelper
end # module Linkto
