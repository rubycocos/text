# encoding: utf-8

module TextUtils
  # make helpers available as class methods e.g. TextUtils.convert_unicode_dashes_to_plain_ascii
  extend UnicodeHelper
  extend TitleHelper
  extend AddressHelper
  
  extend StringFilter # adds asciify and slugify
end



def title_esc_regex( title_unescaped )
  puts "*** warn: depreceated fn call: use TextUtils.title_esc_regex() or include TextUtils::TitleHelpers"
  TextUtils.title_esc_regex( title_unescaped )
end


def find_data_path_from_gemfile_gitref( name )
  puts "[textutils] find_data_path( name='#{name}' )..."
  puts "load path:"
  pp $LOAD_PATH

  # escape chars for regex e.g. . becomes \.
  name_esc = name.gsub( '.', '\.' )


  # note:
  #  - hexdigest must be 12 chars e.g. b7d1c9619a54 or similar
  
  # e.g. match /\/(beer\.db-[a-z0-9]+)|(beer\.db)\//

  name_regex = /\/((#{name_esc}-[a-z0-9]{12})|(#{name_esc}))\/lib$/
  candidates = []
  $LOAD_PATH.each do |path|
    if path =~ name_regex
      # cutoff trailing /lib
      candidates << path[0..-5]
    end
  end

  puts 'found candidates:'
  pp candidates

  ## use first candidate
  candidates[0]
end

