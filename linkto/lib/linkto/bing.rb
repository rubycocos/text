# encoding: utf-8

module Linkto
  module BingHelper


  def link_to_bing_search_images( q, opts={} )
    link_to q, "http://www.bing.com/images/search?q=#{q}", opts
  end

############################
# shortcuts / aliases

  def bing_search_images( q, opts={} ) link_to_bing_search_images( q, opts) end


  end # module BingHelper
end # module Linkto
