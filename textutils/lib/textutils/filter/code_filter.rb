# encoding: utf-8

module TextUtils
  module Filter

  def code_block_curly_style( content, options={} )
    # replace {{{  w/ <pre class='code'>
    # replace }}}  w/ </pre>
    # use 4-6 { or } to escape back to literal value (e.g. {{{{ or {{{{{{ => {{{ )
    # note: {{{ / }}} are anchored to beginning of line ( spaces and tabs before {{{/}}}allowed )
    
    # track statistics
    code_begin     = 0
    code_begin_esc = 0
    code_end       = 0
    code_end_esc   = 0
        
    content.gsub!( /^[ \t]*(\{{3,6})/ ) do |match|
      escaped = ($1.length > 3)
      if escaped
        code_begin_esc += 1
        "{{{"
      else
        code_begin += 1
        "<pre class='code'>"
      end
    end
    
    content.gsub!( /^[ \t]*(\}{3,6})/ ) do |match|
      escaped = ($1.length > 3)
      if escaped
        code_end_esc += 1
        "}}}"
      else
        code_end += 1
        "</pre>"
      end
    end
        
    puts "  Patching {{{/}}}-code blocks (#{code_begin}/#{code_end} blocks, " +
         "#{code_begin_esc}/#{code_end_esc} escaped blocks)..."
    
    content
  end

  end  # module Filter
end   # module TextUtils