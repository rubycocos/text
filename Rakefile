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
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['props'],
    ['logutils'],
    ### 3rd party gems
    ['activesupport']
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }

end
