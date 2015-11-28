# encoding: utf-8

# core and stlibs

require 'json'
require 'yaml'
require 'erb'
require 'pp'
require 'fileutils'
require 'time'
require 'date'


# 3rd party gems / libs
require 'zip'       ### used for .from_zip for readers

### todo/check - document active_support methods that get used
require 'active_support/all'   # String.starts_with?, Object.blank?, etc.


require 'props'
require 'logutils'


# our own code

require 'textutils/version'      ## let version always go first

require 'textutils/patterns'   # regex patterns for reuse
require 'textutils/sanitizier'

require 'textutils/filter/code_filter'
require 'textutils/filter/comment_filter'
require 'textutils/filter/erb_django_filter'
require 'textutils/filter/erb_filter'
require 'textutils/filter/string_filter'

require 'textutils/helper/date_helper'
require 'textutils/helper/hypertext_helper'
require 'textutils/helper/xml_helper'

require 'textutils/helper/unicode_helper'
require 'textutils/helper/tag_helper'
require 'textutils/helper/title_helper'
require 'textutils/helper/address_helper'
require 'textutils/helper/value_helper_i'
require 'textutils/helper/value_helper_ii'
require 'textutils/helper/value_helper_iii_numbers'

require 'textutils/utils'
require 'textutils/core_ext/file'
require 'textutils/core_ext/time'
require 'textutils/core_ext/array'

require 'textutils/parser/name_parser'
require 'textutils/parser/name_tokenizer'

require 'textutils/reader/code_reader'
require 'textutils/reader/hash_reader'
require 'textutils/reader/line_reader'
require 'textutils/reader/values_reader'
require 'textutils/reader/fixture_reader'
require 'textutils/reader/block_reader'
require 'textutils/reader/tree_reader'

require 'textutils/classifier'
require 'textutils/title'    # title table/mapper/finder utils
require 'textutils/title_mapper'
require 'textutils/title_mapper2'

require 'textutils/page'   # for book pages and page templates



# say hello
puts TextUtils.banner   if defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG
