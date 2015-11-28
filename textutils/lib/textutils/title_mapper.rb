# encoding: utf-8


## see textutils/title.rb
##   for existing code
##   move over here

####
## fix: turn it into a class w/ methods
#
#e.g  t =TitleMapper.new( records, name )  # e.g. name='team'
#  t.map!( line )
#  t.find_key!( line )
# etc.


module TextUtils

class TitleMapper      ## todo/check: rename to NameMapper ? why? why not??

  include LogUtils::Logging

  attr_reader :known_titles   ## rename to mapping or mappings or just titles - why? why not?

  def initialize( records, tag )
    @known_titles = build_title_table_for( records )   ## build mapping lookup table

    ## todo: rename tag to attrib or attrib_name - why ?? why not ???
    @tag = tag   # e.g. tag name use for @@brewery@@ @@team@@ etc.
  end


  def map_titles!( line )   ## rename to just map! - why?? why not???
    @known_titles.each do |rec|
      key    = rec[0]
      values = rec[1]
      map_title_for!( @tag, line, key, values )
    end
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

    #### fix/todo:
    ###  reorder - sort by largest strings etc.
    ##   do NOT use lookup w/ array per key; use 1:1 one key per lookup
    ##     -> lets us sort by find largest first


    ## build known tracks table w/ synonyms e.g.
    #
    # [[ 'wolfsbrug', [ 'VfL Wolfsburg' ]],
    #  [ 'augsburg',  [ 'FC Augsburg', 'Augi2', 'Augi3' ]],
    #  [ 'stuttgart', [ 'VfB Stuttgart' ]] ]

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
          extra_title.strip!   # strip leading n trailing withspaces too!
          titles << extra_title
        end
      end


      ## NB: sort here by length (largest goes first - best match)
      #  exclude code and key (key should always go last)
      titles = titles.sort { |left,right| right.length <=> left.length }
      
      ## escape for regex plus allow subs for special chars/accents
      titles = titles.map { |title| TextUtils.title_esc_regex( title )  }

      ## NB: only include code field - if defined
      titles << rec.code          if rec.respond_to?(:code) && rec.code.present?

      known_titles << [ rec.key, titles ]

      logger.debug "  #{rec.class.name}[#{index+1}] #{rec.key} >#{titles.join('|')}<"
    end

    known_titles
  end


  def map_title_for!( tag, line, key, values )

    downcase_tag = tag.downcase

    values.each do |value|
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


end # class TitleMapper
end # module TextUtils
