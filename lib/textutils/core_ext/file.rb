# encoding: utf-8

class File
  def self.read_utf8( path )
    text = open( path, 'r:bom|utf-8' ) do |file|
      file.read
    end

    ## todo/fix:
    ##   normalize newlines
    ##    always use \n
    ##   convert \n\r (Windows)  => \n
    ##   convert \r (old? Mac)   => \n

    # NB: for convenience: convert fancy unicode dashes/hyphens to plain ascii hyphen-minus
    text = TextUtils.convert_unicode_dashes_to_plain_ascii( text, path: path )

    text
  end
end # class File

