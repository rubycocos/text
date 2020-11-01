# encoding: utf-8

module Linkto
  module WikipediaHelper


  def link_to_wikipedia_search( q, opts={} )
    link_to q, "http://en.wikipedia.org/?search=#{q}", opts
  end

  def link_to_wikipedia_de_search( q, opts={} )
    link_to q, "http://de.wikipedia.org/?search=#{q}", opts
  end


###############################
# shortcuts / aliases

  def wikipedia_search( q, opts={} )    link_to_wikipedia_search( q, opts ) end
  def wikipedia_de_search( q, opts={} ) link_to_wikipedia_de_search( q, opts ) end


  end  # module WikipediaHelper
end # module Linkto
