
## $:.unshift(File.dirname(__FILE__))

## minitest setup

# require 'minitest/unit'
require 'minitest/autorun'

# include MiniTest::Unit  # lets us use TestCase instead of MiniTest::Unit::TestCase

## make sure activesupport gets included/required
# note: just activesupport or active_support will NOT work
require 'active_support/all'

## our own code

require 'textutils'
