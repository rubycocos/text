# encoding: utf-8


require 'helper'


class TestGoogle < MiniTest::Unit::TestCase

  include LinktoHelper

  %i( google_search link_to_google_search ).each do |method|
    define_method("test #{method}") do
      assert_equal "<a href='https://www.google.com/search?q=open mundi'>open mundi</a>", send(method, 'open mundi')
    end
  end

  %i( google_de_search link_to_google_de_search ).each do |method|
    define_method("test #{method}") do
      assert_equal "<a href='https://www.google.de/search?hl=de&q=open mundi'>open mundi</a>", send(method, 'open mundi')
    end
  end

end # class TestGoogle
