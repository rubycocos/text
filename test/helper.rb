
## $:.unshift(File.dirname(__FILE__))

## minitest setup

# require 'minitest/unit'
require 'minitest/autorun'

# include MiniTest::Unit  # lets us use TestCase instead of MiniTest::Unit::TestCase

## make sure activesupport gets included/required
# note: just activesupport or active_support will NOT work
# require 'active_support/all'  # -- now included in textutils itself

## our own code

require 'textutils'
