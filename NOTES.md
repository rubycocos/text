# Notes

## Alternatives

### ascii-ify /asciify  (transliterate from unicode (UTF-8) to ASCII (7-bit))

- [stringex gem][github.com/rsl/stringex] - string extensions includes Unidecoder (aka asciify, that is from unicode to ascii); also includes acts_as_url (aka slugifier)

~~~
def decode(string)
  string.chars.map{|char| decoded(char)}.join
end

def decoded(character)
  localized(character) || from_yaml(character)
end

def localized(character)
  Localization.translate(:transliterations, character)
end

# Contains Unicode codepoints, loading as needed from YAML files
CODEPOINTS = Hash.new{|h, k|
  h[k] = ::YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "unidecoder_data", "#{k}.yml"))
} unless defined?(CODEPOINTS)
    
def from_yaml(character)
  return character unless character.ord > 128
  unpacked = character.unpack("U")[0]
  CODEPOINTS[code_group(unpacked)][grouped_point(unpacked)]
rescue
  # Hopefully this won't come up much
  # TODO: Make this note something to the user that is reportable to me perhaps
  "?"
end

# Returns the Unicode codepoint grouping for the given character
def code_group(unpacked_character)
  "x%02x" % (unpacked_character >> 8)
end

# Returns the index of the given character in the YAML file for its codepoint group
def grouped_point(unpacked_character)
  unpacked_character & 255
end
~~~

[(Source - unidecorder.rb)](https://github.com/rsl/stringex/blob/master/lib/stringex/unidecoder.rb)


- [asciify gem](https://github.com/levinalex/asciify) - uses iconv

~~~
def convert(str)
  u16s = @from_input_enc.iconv(str)
  
  s = u16s.unpack(PackFormat).collect { |codepoint|
       codepoint < 128 ? codepoint : @mapping[codepoint]
  }.flatten.compact.pack(PackFormat)
  
  return @to_output_enc.iconv(s)
end
~~~


### slugify

- [slugify gem](https://github.com/Slicertje/Slugify)

~~~
SLUGGY_MAPPING = {
        'Ȃ' => 'a',
        'ȃ' => 'a',
        'Ȅ' => 'e',
        'ȅ' => 'e',
        ...
}

def convert( str )
  result = ''

  str.each_char do |kar|
    if SLUGGY_MAPPING.include?(kar)
      result << SLUGGY_MAPPING[kar]
    end
  end
~~~


- [string_helpers gem](https://github.com/RaphaelIvan/string_helpers)  -- super simple (e.g. just replaces spaces with dashes!, that's it)

~~~
"Jhon Doe".slug! #=> "Jhon-Doe"

def slug!
  self.gsub( " ", "-" )
end
~~~

#### PHP

- [Slugify.php](https://github.com/cocur/slugify)

