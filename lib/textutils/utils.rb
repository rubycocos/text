# encoding: utf-8



module TextUtils
  # make helpers available as class methods e.g. TextUtils.convert_unicode_dashes_to_plain_ascii
  extend UnicodeHelper
  extend TitleHelper
end



class File
  def self.read_utf8( path )
    text = open( path, 'r:bom|utf-8' ) do |file|
      file.read
    end

    # NB: for convenience: convert fancy unicode dashes/hyphens to plain ascii hyphen-minus
    text = TextUtils.convert_unicode_dashes_to_plain_ascii( text, path: path )

    text
  end
end # class File



def title_esc_regex( title_unescaped )
  puts "*** warn: depreceated fn call: use TextUtils.title_esc_regex() or include TextUtils::TitleHelpers"
  TextUtils.title_esc_regex( title_unescaped )
end

