# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_rss.rb
#  or better
#     rake test

require 'helper'


class TestHypertextHelper < Minitest::Test

  include TextUtils::HypertextHelper   #  lets us use textify, etc.

  def test_strip_tags
    ## empty tags
    assert_equal '', strip_tags( '<hr />' )
    assert_equal '', strip_tags( '<hr/>' )
    assert_equal '', strip_tags( '<my-emtpy/>' )
    assert_equal '', strip_tags( '<my-emtpy />' )

    assert_equal 'hello', strip_tags( '<h1>hello</h1>' )
    assert_equal 'hello', strip_tags( '<h2>hello</h2>' )
    assert_equal 'hello', strip_tags( '<p>hello</p>' )
    assert_equal 'hello', strip_tags( '<div>hello</div>' )
    assert_equal 'hello', strip_tags( '<my-header>hello</my-header>' )

    assert_equal 'hello', strip_tags( '<h1 id="test">hello</h1>' )
    assert_equal 'hello', strip_tags( '<p id="test">hello</p>' )
    assert_equal 'hello', strip_tags( '<div id="test">hello</div>' )
    assert_equal 'hello', strip_tags( '<my-header id="test">hello</my-header>' )
    
    ## check case in-sensitive
    assert_equal '', strip_tags( '<HR />' )
    assert_equal '', strip_tags( '<hR />' )
    assert_equal '', strip_tags( '<Hr />' )
    assert_equal '', strip_tags( '<HR/>' )
    assert_equal '', strip_tags( '<My-EmTpY/>' )
    assert_equal '', strip_tags( '<My-EmTpY />' )

    assert_equal 'hello', strip_tags( '<H1>hello</H1>' )
    assert_equal 'hello', strip_tags( '<H2>hello</h2>' )
    assert_equal 'hello', strip_tags( '<P>hello</P>' )
    assert_equal 'hello', strip_tags( '<DiV>hello</dIv>' )
    assert_equal 'hello', strip_tags( '<mY-hEaDer>hello</MY-HEADER>' )

    assert_equal 'hello', strip_tags( '<H1 ID="test">hello</h1>' )
    assert_equal 'hello', strip_tags( '<P id="test">hello</p>' )
    assert_equal 'hello', strip_tags( '<DIV Id="test">hello</dIV>' )
    assert_equal 'hello', strip_tags( '<MY-HEADER iD="test">hello</mY-hEaDeR>' )
  end


  def test_stylesheet_link_tag
    hyout = "<link rel='stylesheet' type='text/css' href='hello.css'>"

    assert_equal( hyout, stylesheet_link_tag( 'hello' ))
    assert_equal( hyout, stylesheet_link_tag( 'hello.css' ))
  end


  def test_sanitize
    hyin =<<EOS
<p><img style="float:left; margin-right:4px" src="http://photos1.meetupstatic.com/photos/event/7/c/b/2/event_244651922.jpeg" alt="photo" class="photo" />vienna.rb</p>
<p>
  <p>The cool guys from <a href="http://platogo.com/">Platogo</a> will sponsor (y)our drinks. Which is awesome.</p>
  <p><strong>Talks</strong>*</p>
  <p>Jakob Sommerhuber - sponsor talk</p>
  <p>Martin Schürrer - Erlang/OTP in production for highly-available, scalable systems</p>
  <p>Markus Prinz - How to improve your code</p>
  <p>Gerald Bauer - working with Sinatra</p>
  <p>Kathrin Folkendt - 'Chapter one' (lightning talk on getting started with Rails, and building her first web app)</p>
  <p><em>*preliminary program</em></p>
</p>
<p>Vienna   - Austria</p>
<p>Friday, October 11 at 6:00 PM</p>
<p>Attending: 21</p>
<p>Details: http://www.meetup.com/vienna-rb/events/130346182/</p>
EOS

    hystep1 = <<EOS
‹p›♦vienna.rb‹/p›
‹p›
  ‹p›The cool guys from Platogo will sponsor (y)our drinks. Which is awesome.‹/p›
  ‹p›Talks*‹/p›
  ‹p›Jakob Sommerhuber - sponsor talk‹/p›
  ‹p›Martin Schürrer - Erlang/OTP in production for highly-available, scalable systems‹/p›
  ‹p›Markus Prinz - How to improve your code‹/p›
  ‹p›Gerald Bauer - working with Sinatra‹/p›
  ‹p›Kathrin Folkendt - 'Chapter one' (lightning talk on getting started with Rails, and building her first web app)‹/p›
  ‹p›*preliminary program‹/p›
‹/p›
‹p›Vienna   - Austria‹/p›
‹p›Friday, October 11 at 6:00 PM‹/p›
‹p›Attending: 21‹/p›
‹p›Details: www.meetup.com/vienna-rb/events/130346182/‹/p›
EOS

    hyout = <<EOS
<p>♦vienna.rb</p>
<p>
  <p>The cool guys from Platogo will sponsor (y)our drinks. Which is awesome.</p>
  <p>Talks*</p>
  <p>Jakob Sommerhuber - sponsor talk</p>
  <p>Martin Schürrer - Erlang/OTP in production for highly-available, scalable systems</p>
  <p>Markus Prinz - How to improve your code</p>
  <p>Gerald Bauer - working with Sinatra</p>
  <p>Kathrin Folkendt - 'Chapter one' (lightning talk on getting started with Rails, and building her first web app)</p>
  <p>*preliminary program</p>
</p>
<p>Vienna   - Austria</p>
<p>Friday, October 11 at 6:00 PM</p>
<p>Attending: 21</p>
<p>Details: www.meetup.com/vienna-rb/events/130346182/</p>
EOS

    assert_equal( hyout, sanitize( hyin ) )

    assert_equal( hystep1, sanitize( hyin, skip_restore: true ) )
  end

end # class TestHypertextHelper
