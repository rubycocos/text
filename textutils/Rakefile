require 'hoe'
require './lib/textutils/version.rb'

Hoe.spec 'textutils' do

  self.version = TextUtils::VERSION
  
  self.summary = 'textutils - Text Filters, Helpers, Readers and More'
  self.description = summary

  self.urls    = ['https://github.com/textkit/textutils']

  self.author  = 'Gerald Bauer'
  self.email   = 'ruby-talk@ruby-lang.org'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['props',    '>=1.1.2'],
    ['logutils', '>=0.6.1'],
    ### 3rd party gems
    ['rubyzip', '>=1.0.0'],   ## note: 1.0 changed to require zip (pre 1.0 was zip/zip); todo/check: make optional -why? why not??
    ['activesupport']    ## todo/check:  really needed? document what methods get used
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 1.9.2'
  }

end
