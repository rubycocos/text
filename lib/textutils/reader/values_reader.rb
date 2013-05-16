# encoding: utf-8

# fix: move into TextUtils namespace/module!!

class ValuesReader

  include LogUtils::Logging
  
  include TextUtils::ValueHelper # e.g. includes find_grade, find_key_n_title


  def initialize( path, more_attribs={} )
    @path = path

    @more_attribs = more_attribs

    @data = File.read_utf8( @path )
  end


##########
# todo/fix:
#  create a new ValuesReaderEx or ValuesReaderV2 or similar
#  - handle tags (last entry, split up into entries)
#  - handle key:value  pairs (split up and return in ordered hash)
# and so on - lets us reuse code for tags and more


  def each_line   # support multi line records

    inside_line = false   # todo: find a better name? e.g. line_found?
    attribs = {}
    more_values = []
      

    @data.each_line do |line|
  
      ## allow alternative comment lines
      ## e.g. -- comment or
      ##      % comment
      ##  why?  # might get used by markdown for marking headers, for example

      ## NB: for now alternative comment lines not allowed as end of line style e.g
      ##  some data, more data   -- comment here

      if line =~ /^\s*#/ || line =~ /^\s*--/ || line =~ /^\s*%/
        # skip komments and do NOT copy to result (keep comments secret!)
        logger.debug 'skipping comment line'
        next
      end

      if line =~ /^\s*$/
        # kommentar oder leerzeile überspringen 
        logger.debug 'skipping blank line'
        next
      end

      # pass 1) remove possible trailing eol comment
      ##  e.g    -> nyc, New York   # Sample EOL Comment Here (with or without commas,,,,)
      ## becomes -> nyc, New York

      line = line.sub( /\s+#.+$/, '' )

      # pass 2) remove leading and trailing whitespace
      
      line = line.strip


      ### check for multiline record
      ##    must start with key and colon   e.g.   brands: 
      if line =~ /^[a-z][a-z0-9.]*[a-z0-9]:/
         # NB: every additional line is one value e.g. city:wien, etc.
         #  allows you to use any chars
         logger.debug "   multi-line record - add key-value »#{line}«"

         more_values.unshift( line.dup )   # add value upfront to array (first value); lets us keep (optional) tags as last entry; fix!! see valuereaderEx v2
         next
      else
        # NB: new record clears/ends multi-line record

        if inside_line  # check if we already processed a line? if yes; yield last line
          yield( attribs, more_values )
          attribs     = {}
          more_values = []
        end
        inside_line = true
      end


      ### guard escaped commas (e.g. \,)
      line = line.gsub( '\,', '♣' )  # use black club suit/=shamrock char for escaped separator
      
      ## use generic separator (allow us to configure separator)
      line = line.gsub( ',', '›')
      
      ## restore escaped commas (before split)
      line = line.gsub( '♣', ',' )

      logger.debug "line: »#{line}«"

      values = line.split( '›' )
      
      # pass 1) remove leading and trailing whitespace for values

      values = values.map { |value| value.strip }

      ##### todo remove support of comment column? (NB: must NOT include commas)
      # pass 2) remove comment columns
      
      values = values.select do |value|
        if value =~ /^#/  ## start with # treat it as a comment column; e.g. remove it
          logger.debug "   removing column with value »#{value}«"
          false
        else
          true
        end
      end

      logger.debug "  values: »#{values.join('« »')}«"

      attribs, more_values = find_key_n_title( values )

      attribs = attribs.merge( @more_attribs )  # e.g. merge country_id and other defaults if present

    end # each lines

    # do NOT forget to yield last line (if present/processed)
    if inside_line
      yield( attribs, more_values )
    end


  end # method each_line


end # class ValuesReader