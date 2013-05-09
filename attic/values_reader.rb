

  def each_line_old_single_line_records_only
      
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

      ### guard escaped commas (e.g. \,)
      line = line.gsub( '\,', '@commma@' )
      
      ## use generic separator (allow us to configure separator)
      line = line.gsub( ',', '@sep@')
      
      ## restore escaped commas (before split)
      line = line.gsub( '@commma@', ',' )


      logger.debug "line: >>#{line}<<"

      values = line.split( '@sep@' )
      
      # pass 1) remove leading and trailing whitespace for values

      values = values.map { |value| value.strip }

      ##### todo remove support of comment column? (NB: must NOT include commas)
      # pass 2) remove comment columns
      
      values = values.select do |value|
        if value =~ /^#/  ## start with # treat it as a comment column; e.g. remove it
          logger.debug "   removing column with value >>#{value}<<"
          false
        else
          true
        end
      end
      
      logger.debug "  values: >>#{values.join('<< >>')}<<"
      
      
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

      ## title (split of optional synonyms)
      # e.g. FC Bayern Muenchen|Bayern Muenchen|Bayern
      titles = title_col.split('|')
      
      attribs[ :title ]    =  titles[0]
     
      ## add optional synonyms if present
      attribs[ :synonyms ] =  titles[1..-1].join('|')  if titles.size > 1
      
      if key_col == '<auto>'
        ## autogenerate key from first title
        key_col = TextUtils.title_to_key( titles[0] )
        logger.debug "   autogen key >#{key_col}< from title >#{titles[0]}<, textutils version #{TextUtils::VERSION}"
      end
      
      attribs[ :key ] = key_col
      
      attribs = attribs.merge( @more_values )  # e.g. merge country_id and other defaults if present
                        
      yield( attribs, more_cols )

    end # each lines

  end # method each_line
