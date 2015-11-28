require 'helper'


class TestFixtureReader < Minitest::Test

  def test_read
    path = "#{TextUtils.root}/test/data/cl_all.txt"
    puts "[TestFixtureReader.test_read] path: #{path}"

    reader = FixtureReader.from_file( path )

    ary = [
      'europe-champions-league!/leagues',
      'europe-champions-league!/2011_12/cl',
      'europe-champions-league!/2011_12/el',
      'europe-champions-league!/2012_13/cl',
      'europe-champions-league!/2012_13/el',
      'europe-champions-league!/2013_14/cl' ]

    i=0
    reader.each do |fx|
      assert_equal ary[i], fx
      i+=1
    end
  end # method test_read

end # class TestFixtureReader

