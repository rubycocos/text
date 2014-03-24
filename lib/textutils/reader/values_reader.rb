# encoding: utf-8

# fix: move into TextUtils namespace/module!!


class ValuesReader

  include LogUtils::Logging
  
  include TextUtils::ValueHelper # e.g. includes find_grade, find_key_n_title


  def initialize( path, more_attribs={} )
    @more_attribs = more_attribs
    
    ### workaround/hack
    #  if path includes newline assume it's a string buffer not a file name
    #  fix: use  from_file an from_string etc. for  ctor
    #   check  what is the best convention (follow  ???)

    if path =~ /\n/m
      @path = 'stringio'   # what name to use ???
      @data = path.dup   # make a duplicate ?? why? why not?
    else
      @path = path
      @data = File.read_utf8( @path )
    end
  end


##########
# todo/fix:
#  create a new ValuesReaderEx or ValuesReaderV2 or similar
#  - handle tags (last entry, split up into entries)
#  - handle key:value  pairs (split up and return in ordered hash)
# and so on - lets us reuse code for tags and more


  def each_line   # support multi line records

    inside_record  = false
    blank_counter  = 0    # count of number of blank lines (note: 1+ blank lines clear multi-line record)
    values         = []

    # keep track of last header
    #  e.g. lines like
    # ___________________________________
    # - Brauerei Schwechat (Brau Union)
    #
    #  laster_header will be 'Brauerei Schwechat (Brau Union)'
    #  gets passed along as an attribue e.g. more_attribs[:header]='Brauerei Schwechat (Brau Union)'
    last_header  = nil


    @data.each_line do |line|

      ## allow alternative comment lines
      ## e.g. -- comment or
      ##      % comment
      ##  why?  # might get used by markdown for marking headers, for example

      ## NB: for now alternative comment lines not allowed as end of line style e.g
      ##  some data, more data   -- comment here

      if line =~ /^\s*#/  ||
         line =~ /^\s*--/ ||
         line =~ /^\s*%/  ||
         line =~ /^\s*__/
        # skip komments and do NOT copy to result (keep comments secret!)
        logger.debug 'skipping comment line'
        next
      end

      if line =~ /^\s*$/
        # kommentar oder leerzeile überspringen 
        blank_counter += 1
        logger.debug "skipping blank line (#{blank_counter})"
        next
      end

      # pass 1) remove possible trailing eol comment
      ##  e.g    -> nyc, New York   # Sample EOL Comment Here (with or without commas,,,,)
      ## becomes -> nyc, New York

      line = line.sub( /\s+#.+$/, '' )

      # pass 2) remove leading and trailing whitespace
      
      line = line.strip


      if line =~ /^-\s+/   # check for group headers  e.g.  - St. James Brewery
        if values.length > 0  # check if we already processed a record? if yes; yield last record (before reset)
          attribs, more_values = find_key_n_title( values )
          attribs = attribs.merge( @more_attribs )  # e.g. merge country_id and other defaults if present
          attribs[:header] = last_header   unless last_header.nil?   # add optional header attrib
          yield( attribs, more_values )
          values         = []
        end
        inside_record  = false
        blank_counter  = 0

        # update last_header
        last_header = line.gsub( /^-\s/, '' )  # cut-off leading marker and space
        logger.info "  update group header >#{last_header}<"
        next
      elsif line =~ /^\[([a-z][a-z]+)\]/
      ### check for multiline record
      ##    must start with key e.g. [guiness]
      ##   for now only supports key with letter a-z (no digits/numbers or underscore or dots)
 
        if values.length > 0  # check if we already processed a record? if yes; yield last record (before reset)
          attribs, more_values = find_key_n_title( values )
          attribs = attribs.merge( @more_attribs )  # e.g. merge country_id and other defaults if present
          attribs[:header] = last_header   unless last_header.nil?   # add optional header attrib
          yield( attribs, more_values )
          values         = []
        end
        inside_record  = true
        blank_counter  = 0

        # NB: every additional line is one value e.g. city:wien, etc.
        #  allows you to use any chars
        logger.debug "   multi-line record w/ key »#{$1}«"

        values         = [$1.dup]    # add key as first value in ary
      elsif inside_record && blank_counter == 0 && line =~ /\/{2}/ # check address line (must contain //)
        values += [line.dup]     # assume single value column (no need to escape commas)
      elsif inside_record && blank_counter == 0 && line =~ /^[a-z][a-z0-9.]*[a-z0-9]:/ # check key: value pair
        values += [line.dup]     # assume single value column (no need to escape commas)
      else
        if inside_record && blank_counter == 0   # continue adding more values
          values += find_values( line )
        else                                     # assume single-line (stand-alone / classic csv) record          
          if values.length > 0
            attribs, more_values = find_key_n_title( values )
            attribs = attribs.merge( @more_attribs )  # e.g. merge country_id and other defaults if present
            attribs[:header] = last_header   unless last_header.nil?   # add optional header attrib
            yield( attribs, more_values )
            values         = []
          end
          inside_record  = false
          blank_counter  = 0
          values = find_values( line )
        end
      end

    end # each lines

    # do NOT forget to yield last line (if present/processed)
    if values.length > 0
      attribs, more_values = find_key_n_title( values )
      attribs = attribs.merge( @more_attribs )  # e.g. merge country_id and other defaults if present
      attribs[:header] = last_header   unless last_header.nil?   # add optional header attrib
      yield( attribs, more_values )
    end

  end # method each_line


  ### todo:
  ##   move to helper for reuse a la find_key_n_title ???  
  ##  use different/better name ?? e.g. find_values_in_line  or split_line_into_values ??
  def find_values( line )
    ## note returns an array of values (strings)

    meta_comma     = '«KOMMA»'
    meta_separator = '« »'

    # guard escaped commas
    #  e.g. convert \, to «KOMMA»
    line = line.gsub( '\,', meta_comma )

    # note: use generic separator (allow us to configure separator)
    #  e.g « »
    line = line.gsub( ',', meta_separator )

    # restore escaped commas (before split)
    line = line.gsub( meta_comma, ',' )

    logger.debug "line: |»#{line}«|"

    values = line.split( meta_separator )

    # pass 1) remove leading and trailing whitespace for values

    values = values.map { |value| value.strip }


    ##### todo/fix:
    #  !!!REMOVE!!!
    # remove support of comment column? (NB: must NOT include commas)
    # pass 2) remove comment columns
    #
    #  todo/fix: check if still possible ?? - add an example here how it looks like/works

    values = values.select do |value|
      if value =~ /^#/  ## start with # treat it as a comment column; e.g. remove it
        logger.info "   removing column with value »#{value}«"
        false
      else
        true
      end
    end

    logger.debug "  values: |»#{values.join('« »')}«|"
    values
  end


end # class ValuesReader