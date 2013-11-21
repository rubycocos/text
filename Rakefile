require 'hoe'
require './lib/textutils/version.rb'

Hoe.spec 'textutils' do
  
  self.version = TextUtils::VERSION
  
  self.summary = 'textutils - Text Filters, Helpers, Readers and More'
  self.description = summary

  self.urls    = ['https://github.com/rubylibs/textutils']

  self.author  = 'Gerald Bauer'
  self.email   = 'ruby-talk@ruby-lang.org'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.markdown'
  self.history_file = 'History.markdown'

  self.extra_deps = [
    ['logutils', '~> 0.5']  # e.g. >= 0.5 <= 1.0
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }
  

end