# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_page.rb


require 'helper'


class TestPage < MiniTest::Test

def test_page1
  page = Pakman::Page.from_file( "#{Pakman.root}/test/pages/page1.txt" )
  assert page.headers?
end  # method test_page1

def test_page2
  page = Pakman::Page.from_file( "#{Pakman.root}/test/pages/page2.txt" )
  assert page.headers?
end  # method test_page2

def test_page3
  page = Pakman::Page.from_file( "#{Pakman.root}/test/pages/page3.txt" )
  assert page.headers?
end  # method test_page3

def test_empty
  page = Pakman::Page.from_file( "#{Pakman.root}/test/pages/empty.txt" )
  assert page.headers? == false
end  # method test_empty

def test_text
  page = Pakman::Page.from_file( "#{Pakman.root}/test/pages/text.txt" )
  assert page.headers? == false
end  # method test_text

end # class TestPage



