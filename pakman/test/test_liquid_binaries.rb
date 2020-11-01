# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_liquid_binaries.rb


require 'helper'


class TestLiquidBinaries < MiniTest::Test


def setup
  Liquid::Template.error_mode = :strict
end


def test_rx
    rx = Pakman::LiquidTemplater::REGEX_EXT

    pp rx

    ## todo: check why assert rx.match( 'test.html' ) == true doesn't work
    ##  (note: regex.match will return MatchData or nil)

    assert rx.match( 'test.html' ).nil? == false
    assert rx.match( 'TEST.HTML' ).nil? == false
    assert rx.match( 'test.js' ).nil?   == false
    assert rx.match( 'test.json' ).nil? == false
    assert rx.match( 'test.gif' ).nil?  == true
end


def test_merge
  hash = YAML.load_file( "#{Pakman.root}/test/data/test.yml" )
  ctx= { 'headers' => hash['headers'], 'slides' => hash['slides'] }
  pp ctx

  manifestsrc = "#{Pakman.root}/test/liquid/pak/testbin.txt"
  outpath = "#{Pakman.root}/tmp/#{Time.now.to_i}"    ## pakpath/output path

  Pakman::LiquidTemplater.new.merge_pak( manifestsrc, outpath, ctx, 'test' )

  assert true
end  # method test_merge

end # class TestLiquidBinaries
