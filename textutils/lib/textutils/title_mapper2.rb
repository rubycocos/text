# encoding: utf-8


## see textutils/title.rb
##   for existing code
##   move over here


module TextUtils

class TitleMapper2      ## todo/check: rename to NameMapper ? why? why not??

  include LogUtils::Logging

  attr_reader :known_titles   ## rename to mapping or mappings or just titles - why? why not?

  ##
  ##  key:      e.g. augsburg 
  ##  title:    e.g. FC Augsburg
  ##  length (of title - not pattern):   e.g. 11   -- do not count dots (e.g. U.S.A. => 3 or 6) why? why not? 
  MappingStruct =  Struct.new( :key, :title, :length, :pattern)   ## todo/check: use (rename to) TitleStruct - why? why not??


  def initialize( records, tag )
    @known_titles = build_title_table_for( records )   ## build mapping lookup table

    ## todo: rename tag to attrib or attrib_name - why ?? why not ???
    @tag = tag   # e.g. tag name use for @@brewery@@ @@team@@ etc.
  end


  def map_titles!( line )   ## rename to just map! - why?? why not???
    begin
      found = map_title_for!( @tag, line, @known_titles )
    end while found
  end

  def find_key!( line )
    find_key_for!( @tag, line )
  end

  def find_keys!( line )  # NB: keys (plural!) - will return array
    counter = 1
    keys = []

    key = find_key_for!( "#{@tag}#{counter}", line )
    while key.present?
      keys << key
      counter += 1
      key = find_key_for!( "#{@tag}#{counter}", line )
    end
    keys
  end


private
  def build_title_table_for( records )

    ## build known tracks table w/ synonyms e.g.
    #
    # [[ 'wolfsbrug', 'VfL Wolfsburg'],
    #  [ 'augsburg',  'FC Augsburg'],
    #  [ 'augsburg',  'Augi2'],
    #  [ 'augsburg',  'Augi3' ],
    #  [ 'stuttgart', 'VfB Stuttgart']]

    known_titles = []

    records.each_with_index do |rec,index|

      title_candidates = []
      title_candidates << rec.title

      title_candidates += rec.synonyms.split('|') if rec.synonyms.present?


      ## check if title includes subtitle e.g. Grand Prix Japan (Suzuka Circuit)
      #  make subtitle optional by adding title w/o subtitle e.g. Grand Prix Japan

      titles = []
      title_candidates.each do |t|
        titles << t
        if t =~ /\(.+\)/
          extra_title = t.gsub( /\(.+\)/, '' ) # remove/delete subtitles
          # note: strip leading n trailing withspaces too!
          #  -- todo: add squish or something if () is inline e.g. leaves two spaces?
          extra_title.strip!
          titles << extra_title
        end
      end

      titles.each do |t|
        m = MappingStruct.new
        m.key     = rec.key
        m.title   = t
        m.length  = t.length
        ## note: escape for regex plus allow subs for special chars/accents
        m.pattern = TextUtils.title_esc_regex( t )
      
        known_titles << m
      end

      logger.debug "  #{rec.class.name}[#{index+1}] #{rec.key} >#{titles.join('|')}<"      

      ## NB: only include code field - if defined
      if rec.respond_to?(:code) && rec.code.present?
        m = MappingStruct.new
        m.key     = rec.key
        m.title   = rec.code
        m.length  = rec.code.length
        m.pattern = rec.code   ## note: use code for now as is (no variants allowed fow now)

        known_titles << m      
      end
    end

    ## note: sort here by length (largest goes first - best match)
      #  exclude code and key (key should always go last)
    known_titles = known_titles.sort { |left,right| right.length <=> left.length }
    known_titles
  end


  def map_title_for!( tag, line, mappings )

    downcase_tag = tag.downcase

    mappings.each do |mapping|
      
      key   = mapping.key
      value = mapping.pattern
      ## nb: \b does NOT include space or newline for word boundry (only alphanums e.g. a-z0-9)
      ## (thus add it, allows match for Benfica Lis.  for example - note . at the end)

      ## check add $ e.g. (\b| |\t|$) does this work? - check w/ Benfica Lis.$
      regex = /\b#{value}(\b| |\t|$)/   # wrap with world boundry (e.g. match only whole words e.g. not wac in wacker) 
      if line =~ regex
        logger.debug "     match for #{downcase_tag}  >#{key}< >#{value}<"
        # make sure @@oo{key}oo@@ doesn't match itself with other key e.g. wacker, wac, etc.
        line.sub!( regex, "@@oo#{key}oo@@ " )    # NB: add one space char at end
        return true    # break out after first match (do NOT continue)
      end
    end
    return false
  end


  def find_key_for!( tag, line )
    regex = /@@oo([^@]+?)oo@@/     # e.g. everything in @@ .... @@ (use non-greedy +? plus all chars but not @, that is [^@])

    upcase_tag    = tag.upcase
    downcase_tag  = tag.downcase

    if line =~ regex
      value = "#{$1}"
      logger.debug "   #{downcase_tag}: >#{value}<"
      
      line.sub!( regex, "[#{upcase_tag}]" )

      return $1
    else
      return nil
    end
  end # method find_key_for!


end # class TitleMapper2
end # module TextUtils
