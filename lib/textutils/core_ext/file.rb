# encoding: utf-8

class File
  def self.read_utf8( path )
    text = open( path, 'r:bom|utf-8' ) do |file|
      file.read
    end

    ##
    ## todo: make normalize newlines into a filter (for easy (re)use)

    ##   normalize newlines
    ##    always use LF \n (Unix):
    ##
    ##   convert CR/LF \r\n (Windows)  => \n
    ##   convert CR    \r   (old? Mac) => \n  -- still in use?
    text = text.gsub( /\r\n|\r/, "\n" )

    # NB: for convenience: convert fancy unicode dashes/hyphens to plain ascii hyphen-minus
    text = TextUtils.convert_unicode_dashes_to_plain_ascii( text, path: path )

    text
  end
end # class File

