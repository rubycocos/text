
# core and stlibs

require 'yaml'
require 'pp'
require 'logger'
require 'optparse'
require 'fileutils'
require 'erb'


# our own code

require 'textutils/filter/code_filter'
require 'textutils/filter/comment_filter'
require 'textutils/filter/erb_django_filter'
require 'textutils/filter/erb_filter'

require 'textutils/utils'
require 'textutils/reader/code_reader'
require 'textutils/reader/hash_reader'
require 'textutils/reader/line_reader'
require 'textutils/reader/values_reader'



module TextUtils

  VERSION = '0.3.0'

end   # module TextUtils
