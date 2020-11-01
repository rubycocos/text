# encoding: utf-8

module Pakman


  # downcase and remove .txt (if anywhere in name)
  # e.g. welcome.quick.txt becomes welcome.quick
  #      welcome.txt.quick becomse welcome.quick
  #      s6blank.txt becomes s6blank

  def self.pakname_from_file( path )
    File.basename( path ).downcase.gsub( '.txt', '' )
  end

end # class Pakman
