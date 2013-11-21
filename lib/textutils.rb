
# core and stlibs

require 'yaml'
require 'pp'
require 'logger'
require 'optparse'
require 'fileutils'
require 'erb'

# 3rd party gems / libs

require 'logutils'

# our own code

require 'textutils/version'

require 'textutils/patterns'   # regex patterns for reuse
require 'textutils/sanitizier'

require 'textutils/filter/code_filter'
require 'textutils/filter/comment_filter'
require 'textutils/filter/erb_django_filter'
require 'textutils/filter/erb_filter'

require 'textutils/helper/date_helper'
require 'textutils/helper/hypertext_helper'
require 'textutils/helper/xml_helper'

require 'textutils/helper/unicode_helper'
require 'textutils/helper/tag_helper'
require 'textutils/helper/title_helper'
require 'textutils/helper/address_helper'
require 'textutils/helper/value_helper'

require 'textutils/utils'
require 'textutils/reader/code_reader'
require 'textutils/reader/hash_reader'
require 'textutils/reader/line_reader'
require 'textutils/reader/values_reader'
require 'textutils/reader/fixture_reader'

require 'textutils/classifier'

