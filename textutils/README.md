# `textutils`

Text Filters, Helpers, Readers and More in Ruby

* home  :: [github.com/textkit/textutils](https://github.com/textkit/textutils)
* bugs  :: [github.com/textkit/textutils/issues](https://github.com/textkit/textutils/issues)
* gem   :: [rubygems.org/gems/textutils](https://rubygems.org/gems/textutils)
* rdoc  :: [rubydoc.info/gems/textutils](http://rubydoc.info/gems/textutils)
* forum :: [ruby-talk@ruby-lang.org](www.ruby-lang.org/en/community/mailing-lists/)



## Filters

### `comments_percent_style` Filter

Strip comment lines starting with percent (that is, %). Example:

    %%%%%%%%%%%%%%%%
    % Some Headers
    
    Title: Web Services REST-Style: Universal Identifiers, Formats & Protocols
    
    %%%%%%%%%%%%%%%%%%%
    % Some Extra CSS
    
    table { width: 100%; }
    table#restspeak th:nth-child(1) { width: 20%; }
    table#restspeak th:nth-child(2) { width: 5%; }

Becomes

    Title: Web Services REST-Style: Universal Identifiers, Formats & Protocols
    
    table { width: 100%; }
    table#restspeak th:nth-child(1) { width: 20%; }
    table#restspeak th:nth-child(2) { width: 5%; }

Also supports multiline comments with `%begin`|`comment`|`comments`/`%end` pairs. Example:

    %begin
    Using modern browser such as Firefox, Chrome and Safari you can
    now theme your slide shows using using "loss-free" vector graphics
    in plain old CSS. Thanks to gradient support in backgrounds in CSS3.
    %end

or

    %comment
    Using modern browser such as Firefox, Chrome and Safari you can
    now theme your slide shows using using "loss-free" vector graphics
    in plain old CSS. Thanks to gradient support in backgrounds in CSS3.
    %end

Note: As a shortcut using a single `%end` directive (that is, without a leading `%begin`)
will skip everything until the end of the document.


### `skip_end_directive` Filter

Skip (comment out) text blocks in your document by
enclosing with `__SKIP__`/`__END__`. Example:

    __SKIP__
    Using modern browser such as Firefox, Chrome and Safari you can
    now theme your slide shows using using "loss-free" vector graphics
    in plain old CSS. Thanks to gradient support in backgrounds in CSS3.
    __END__

Note: As a shortcut using just `__END__` (without `__SKIP__`)
will skip everything from `__END__` until the end of the document.


TBD

## Helpers

TBD


## Install

Just install the gem:

    $ gem install textutils


## Real World Usage

The [`slideshow`](http://slideshow-s9.github.io) gem (also known as Slide Show (S9))
that lets you create slide shows
and author slides in plain text using a wiki-style markup language that's easy-to-write and easy-to-read.

The [`markdown`](https://github.com/writekit/markdown) gem that lets you use your markdown library
of choice.

The [`worlddb`](https://github.com/worlddb/world.db.ruby) gem that offers a command line tool for the open world database (`world.db`).

The [`sportdb`](https://github.com/sportdb/sport.db.ruby) gem that offers a command line tool for the open sport/football database (`sport.db`/`football.db`).


## License

The `textutils` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
