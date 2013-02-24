require 'hoe'
require './lib/textutils/version.rb'

Hoe.spec 'textutils' do
  
  self.version = TextUtils::VERSION
  
  self.summary = 'textutils - Text Filters, Helpers, Readers and More'
  self.description = summary

  self.urls    = ['http://geraldb.github.com/textutils']

  self.author  = 'Gerald Bauer'
  self.email   = 'webslideshow@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.markdown'
  self.history_file = 'History.markdown'

  self.extra_deps = [
    ['logutils', '>= 0.5.0']
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }
  

end