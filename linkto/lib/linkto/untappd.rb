# encoding: utf-8

module Linkto
  module UntappdHelper


  def link_to_untappd_search( q, opts={} )
    link_to q, "https://untappd.com/search?q=#{q}", opts
  end


###############################
# shortcuts / aliases

  def untappd_search( q, opts={} ) link_to_untappd_search( q, opts )  end


  end # module UntappdHelper
end # module Linkto
