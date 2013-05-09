# encoding: utf-8


module TextUtils
  module AddressHelper

  def normalize_address( old_address_line )
    # for now only checks german 5-digit zip code
    #
    #  e.g.  Alte Plauener Straße 24 // 95028 Hof  becomes
    #        95028 Hof // Alte Plauener Straße 24 

    new_address_line = old_address_line   # default - do nothing - just path through

    lines = old_address_line.split( '//' )

    if lines.size == 2   # two lines / check for switching lines
      line1 = lines[0].strip
      line2 = lines[1].strip
      if line2 =~ /^[0-9]{5}\s/
        new_address_line = "#{line2} // #{line1}"   # swap - let line w/ 5-digit zip code go first
      end
    end

    new_address_line
  end

  end # module AddressHelper
end # module TextUtils
