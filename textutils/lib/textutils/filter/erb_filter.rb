# encoding: utf-8

module TextUtils
  module Filter

  # allow plugins/helpers; process source (including header) using erb    
  def erb( content, options={} )
    puts "  Running embedded Ruby (erb) code/helpers..."
    
    content =  ERB.new( content ).result( binding() )
    content
  end

  end  # module Filter
end   # module TextUtils