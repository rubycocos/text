# encoding: utf-8


# core and stlibs

require 'yaml'
require 'pp'
require 'logger'
require 'optparse'
require 'fileutils'
require 'erb'

# 3rd party gems / libs

require 'zip'


# fix: remove version from activerecord in deps
require 'active_support/all'   # String.starts_with?, Object.blank?, etc.

require 'props'
require 'props/db'   ## for Prop model --> move create_from fixtures to textutils!!
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
require 'textutils/helper/value_helper'

require 'textutils/utils'
require 'textutils/core_ext/file'
require 'textutils/core_ext/time'

require 'textutils/parser/name_parser'

require 'textutils/reader/code_reader'
require 'textutils/reader/hash_reader'
require 'textutils/reader/hash_reader_v2'
require 'textutils/reader/line_reader'
require 'textutils/reader/line_reader_v2'
require 'textutils/reader/values_reader'
require 'textutils/reader/values_reader_v2'
require 'textutils/reader/fixture_reader'

require 'textutils/classifier'
require 'textutils/title'    # title table/mapper/finder utils

require 'textutils/page'   # for book pages and page templates




puts TextUtils.banner   if $DEBUG    # say hello
