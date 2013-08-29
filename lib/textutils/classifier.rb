# encoding: utf-8

module TextUtils

class Classifier

  include LogUtils::Logging

  def initialize
    @h = Hash.new( [] )  # hash w/ words - default value is empty ary (word_list)
  end

  def train( key, ary_or_hash_or_str )

    ## add words to lang/topic key

    if ary_or_hash_or_str.kind_of?( Array )
      words = ary_or_hash_or_str
    elsif ary_or_hash_or_str.kind_of?( Hash )
      words = []
      ary_or_hash_or_str.each do |_, values|
        words += values.strip.split('|')
      end
    else  # assume string (allow list separated by |)
      words = ary_or_hash_or_str.strip.split('|')
    end

    @h[ key ] += words
  end

  def classify_file( path )
    classify( File.read_utf8( path ) )
  end

  def classify( text_with_comments )

    ## check encoding
    logger.debug "  classify - text.encoding: #{text_with_comments.encoding.name}"
    
    # nb: strip comments first
    text = strip_comments( text_with_comments )

    counts = []
      ## e.g. [[ 'en', 20], # 20 words
      ##       [ 'de',  2]] # 2 words

    @h.each_with_index do |(key,words),i|
      logger.debug "key #{key} (#{i+1}/#{@h.size}) - #{words.size} words"
      counts << [key, count_words_in_text( words, text )]
    end

    # sort by word count (reverse sort e.g. highest count goes first)
    counts = counts.sort {|l,r| r[1] <=> l[1] }
    
    # dump stats
    
    logger.debug "results:"
    counts.each_with_index do |entry,i|
      ## e.g. 1. en: 20 words
      ##      2. de: 2 words
      logger.debug " #{i+1}. #{entry[0]}: #{entry[1]}"
    end
    
    logger.debug "classifier - using key >>#{counts[0][0]}<<"
    
    ## return key/lang code w/ highest count
    counts[0][0]
  end


  def dump
    # for debugging dump setup (that is, keys w/ words etc.)

    @h.each_with_index do |(key, words), i|
      logger.debug "key #{key} (#{i+1}/#{@h.size}) - #{words.size} words:"
      logger.debug words.inspect
      
      ## check encoding of words (trouble w/ windows cp850 argh!!!)
      last_encoding_name = ''
      words.each do |word|
        if last_encoding_name != word.encoding.name
          logger.debug "  encoding: #{word.encoding.name}"
          last_encoding_name = word.encoding.name
        end
      end
    end 
  end


private
  def strip_comments( text )
    new_text = ''

    text.each_line do |line|
  
      # comments allow:
      # 1) #####  (shell/ruby style)
      # 2) --  comment here (haskel/?? style)
      # 3) % comment here (tex/latex style)

      if line =~ /^\s*#/ || line =~ /^\s*--/ || line =~ /^\s*%/
        # skip komments and do NOT copy to result (keep comments secret!)
        logger.debug 'skipping comment line'
        next
      end

      ## todo: strip inline comments  - why not?

      # pass 1) remove possible trailing eol comment
      ##  e.g    -> nyc, New York   # Sample EOL Comment Here (with or without commas,,,,)
      ## becomes -> nyc, New York

      line = line.sub( /\s+#.+$/, '' )

      new_text << line
      new_text << "\n"
    end

    new_text
  end


  def count_word_in_text( word, text )
    count = 0
    pos = text.index( word )
    while pos.nil? == false
      count += 1
      logger.debug "bingo - found >>#{word}<< on pos #{pos}, count: #{count}"
      ### todo: check if pos+word.length/size needs +1 or similar
      pos = text.index( word, pos+word.length)
    end
    count
  end

  def count_words_in_text( words, text )
    count = 0
    words.each do |word|
      count += count_word_in_text( word, text )
    end
    count
  end


end # class Classifier

end # module TextUtils
