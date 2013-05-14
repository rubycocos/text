# encoding: utf-8

# fix: move into TextUtils namespace/module!!

class ValuesReader

  include LogUtils::Logging
  
  include TextUtils::ValueHelper # e.g. includes find_grade()


  def initialize( path, more_values={} )
    @path = path

    @more_values = more_values

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
    attribs = {}     # rename to new_attributes?
    more_cols = []   # rename to more_values?
      

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

         more_cols.unshift( line.dup )   # add value upfront to array (first value); lets us keep (optional) tags as last entry; fix!! see valuereaderEx v2
         next
      else
        # NB: new record clears/ends multi-line record
        
        if inside_line  # check if we already processed a line? if yes; yield last line
          yield( attribs, more_cols )
          attribs   = {}
          more_cols = []
        end
        inside_line = true
      end


      ### guard escaped commas (e.g. \,)
      line = line.gsub( '\,', '♣' )  # use black club suit/=shamrock char for escaped separator
      
      ## use generic separator (allow us to configure separator)
      line = line.gsub( ',', '♦')  # use black diamond suit for separator
      
      ## restore escaped commas (before split)
      line = line.gsub( '♣', ',' )

      logger.debug "line: »#{line}«"

      values = line.split( '♦' )
      
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
      
      
      ### todo/fix: allow check - do NOT allow mixed use of with key and w/o key
      ##  either use keys or do NOT use keys; do NOT mix in a single fixture file
      
      
      ### support autogenerate key from first title value
      
      # if it looks like a key (only a-z lower case allowed); assume it's a key
      #   - also allow . in keys e.g. world.quali.america, at.cup, etc.
      #   - also allow 0-9 in keys e.g. at.2, at.3.1, etc.

      # fix/todo: add support for leading underscore _
      #   or allow keys starting w/ digits?
      if values[0] =~ /^([a-z][a-z0-9.]*[a-z0-9]|[a-z])$/    # NB: key must start w/ a-z letter (NB: minimum one letter possible)
        key_col         = values[0]
        title_col       = values[1]
        more_cols       = values[2..-1]
      else
        key_col         = '<auto>'
        title_col       = values[0]
        more_cols       = values[1..-1]
      end

      attribs = {}

      ## check title_col for grade (e.g. ***/**/*) and use returned stripped title_col if exits
      grade, title_col = find_grade( title_col )

      # NB: for now - do NOT include default grade e.g. if grade (***/**/*) not present; attrib will not be present too
      if grade == 1 || grade == 2 || grade == 3  # grade found/present
        logger.debug "   found grade #{grade} in title"
        attribs[:grade] = grade
      end

      ## title (split of optional synonyms)
      # e.g. FC Bayern Muenchen|Bayern Muenchen|Bayern
      titles = title_col.split('|')
      
      attribs[ :title ]    =  titles[0]
     
      ## add optional synonyms if present
      attribs[ :synonyms ] =  titles[1..-1].join('|')  if titles.size > 1
      
      if key_col == '<auto>'
        ## autogenerate key from first title
        key_col = TextUtils.title_to_key( titles[0] )
        logger.debug "   autogen key »#{key_col}« from title »#{titles[0]}«, textutils version #{TextUtils::VERSION}"
      end
      
      attribs[ :key ] = key_col
      
      attribs = attribs.merge( @more_values )  # e.g. merge country_id and other defaults if present
                        
    end # each lines

    # do NOT forget to yield last line (if present/processed)
    if inside_line
      yield( attribs, more_cols )
    end


  end # method each_line


end # class ValuesReader