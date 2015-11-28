# encoding: utf-8


class Array

  ## todo: check if there's already a builtin method for this
  #
  #  note:
  #   in rails ary.in_groups(3)  results in
  #          top-to-bottom, left-to-right.
  #  and not left-to-right first and than top-to-bottom.
  #
  #  rename to in_groups_vertical(3) ???

  def in_columns( cols )  # alias for convenience for chunks - needed? why? why not?
    chunks( cols )
  end

  def chunks( number_of_chunks )
    ## NB: use chunks - columns might be in use by ActiveRecord! 
    ###
    # e.g.
    #  [1,2,3,4,5,6,7,8,9,10].columns(3)
    #   becomes:
    #  [[1,4,7,10],
    #   [2,5,8],
    #   [3,6,9]]

    ## check/todo: make a copy of the array first??
    #  for now reference to original items get added to columns
    chunks = (1..number_of_chunks).collect { [] }
    each_with_index do |item,index|
      chunks[ index % number_of_chunks ] << item
    end
    chunks
  end

end # class Array

