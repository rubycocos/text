# encoding: utf-8

module Pakman

class Ctx   # Context

  def initialize( hash )
    @hash = hash
  end

  def ctx
    ### todo: check if method_missing works with binding in erb???
    binding
  end

  def method_missing( mn, *args, &blk )
    ## only allow read-only access (no arguments)
    if args.length > 0    # || mn[-1].chr == "="
      return super # super( mn, *args, &blk )
    end

    key = mn.to_s

    if @hash.has_key?( key )
      puts "calling ctx.#{key}"
      value = @hash[ key ]
      puts "  returning #{value.class.name}:"
      pp value
      value
    else
      puts "*** warning: ctx.#{key} missing"
      super
    end
  end

end # class Ctx
end # module Pakman
