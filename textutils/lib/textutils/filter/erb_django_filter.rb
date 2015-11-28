# encoding: utf-8

module TextUtils
  module Filter

  def erb_django_style( content, options={} )

    # replace expressions (support for single lines only)
    #  {{ expr }}  ->  <%= expr %>
    #  {% stmt %}  ->  <%  stmt %>   !! add in do if missing (for convenience)
    #
    # use use {{{ or {{{{ to escape expr back to literal value
    # and use {%% %} to escape stmts

    erb_expr = 0
    erb_stmt_beg = 0
    erb_stmt_end = 0

    content.gsub!( /(\{{2,4})([^{}\n]+?)(\}{2,4})/ ) do |match|
      escaped = ($1.length > 2)
      if escaped
        "{{#{$2}}}"
      else
        erb_expr += 1
        "<%= #{erb_django_simple_params($2)} %>"
      end
    end

    content.gsub!( /(\{%{1,2})([ \t]*end[ \t]*)%\}/ ) do |match|
      escaped = ($1.length > 2)
      if escaped
        "{%#{$2}%}"
      else
        erb_stmt_end += 1
        "<% end %>"
      end
    end

    content.gsub!( /(\{%{1,2})([^%\n]+?)%\}/ ) do |match|
      escaped = ($1.length > 2)
      if escaped
        "{%#{$2}%}"
      else
        erb_stmt_beg += 1
        "<% #{erb_django_simple_params($2)} do %>"
      end
    end

    puts "  Patching embedded Ruby (erb) code Django-style (#{erb_expr} {{-expressions," +
       " #{erb_stmt_beg}/#{erb_stmt_end} {%-statements)..."
         
    content
  end



######################
## "private" helpers - do NOT use as filters - todo: add :nodoc: how?

  def erb_django_simple_params( code )
    
    # split into method/directive and parms plus convert params
    code.sub!( /^[ \t]([\w.]+)(.*)/ ) do |match|
      directive = $1
      params    = $2
      
      "#{directive} #{params ? erb_simple_params(directive,params) : ''}"
    end
    
    code
  end

  def erb_simple_params( method, params )
    
    # replace params to support html like attributes e.g.
    #  plus add comma separator
    #
    #  class=part       -> :class => 'part'   
    #  3rd/tutorial     -> '3rd/tutorial'
    #  :css             -> :css
    
    return params   if params.nil? || params.strip.empty?

    params.strip!    
    ## todo: add check for " ??
    if params.include?( '=>' )
      puts "** warning: skipping patching of params for helper '#{method}'; already includes '=>':"
      puts "  #{params}"
      
      return params
    end
    
    before = params.clone
    
    # 1) string-ify values and keys (that is, wrap in '')
    #  plus separate w/ commas
    params.gsub!( /([:a-zA-Z0-9#][\w\/\-\.#()]*)|('[^'\n]*')/) do |match|
      symbol = ( Regexp.last_match( 0 )[0,1] == ':' )
      quoted = ( Regexp.last_match( 0 )[0,1] == "'" )
      if symbol || quoted  # return symbols or quoted string as is
        "#{Regexp.last_match( 0 )},"
      else
        "'#{Regexp.last_match( 0 )}',"
      end
    end
        
    # 2) symbol-ize hash keys
    #    change = to =>
    #    remove comma for key/value pairs
    params.gsub!( /'(\w+)',[ \t]*=/ ) do |match|
      ":#{$1}=>"
    end
    
    # 3) remove trailing comma
    params.sub!( /[ \t]*,[ \t]*$/, '' ) 
     
    puts "    Patching params for helper '#{method}' from '#{before}' to:"
    puts "      #{params}"
       
    params
  end


  end  # module Filter
end   # module TextUtils