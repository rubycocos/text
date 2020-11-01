

## require 'props'

require 'logutils'

## require 'textutils'


# our own code

require 'linkto/version'  # let it always go first

require 'linkto/bing'
require 'linkto/flickr'
require 'linkto/google'
require 'linkto/untappd'
require 'linkto/wikipedia'


module Linkto

  def self.banner
    "linkto/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end  

### convenience - includes all helpers; use include LinktoHelper
  module Helper
    include BingHelper
    include FlickrHelper
    include GoogleHelper
    include UntappdHelper
    include WikipediaHelper
  end

end  # module Linkto


## for convenience add aliases for module
LinkTo       = Linkto
LinkToHelper = Linkto::Helper 
LinktoHelper = Linkto::Helper


puts Linkto.banner    # say hello
