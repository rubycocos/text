# encoding: utf-8

module TextUtils
  module Filter

  def comments_percent_style( content, options={} )

    # remove comments
    # % comments
    # %begin multiline comment
    # %end multiline comment

    # track statistics
    comments_multi  = 0
    comments_single = 0
    comments_end    = 0

    # remove multi-line comments
    content.gsub!(/^%(begin|comment|comments).*?%end/m) do |match|
      comments_multi += 1
      ""
    end
    
     # remove everyting starting w/ %end (note, can only be once in file) 
    content.sub!(/^%end.*/m) do |match|
      comments_end += 1
      ""
    end

    # hack/note: 
    #  note multi-line erb expressions/stmts might cause trouble
    #  
    #  %> gets escaped as special case (not treated as comment)
    # <%
    #   whatever
    # %> <!-- trouble here; would get removed as comment!
    #  todo: issue warning?
    
    # remove single-line comments    
    content.gsub!(/(^%$)|(^%[^>].*)/ ) do |match|
      comments_single += 1
      ""
    end
    
    puts "  Removing %-comments (#{comments_single} lines, " +
       "#{comments_multi} begin/end-blocks, #{comments_end} end-blocks)..."
    
    content
  end

  def skip_end_directive( content, options={} )
    # codex-style __SKIP__, __END__ directive
    # ruby note: .*? is non-greedy (shortest-possible) regex match
    content.gsub!(/__SKIP__.*?__END__/m, '')
    content.sub!(/__END__.*/m, '')
    content
  end


  end  # module Filter
end   # module TextUtils