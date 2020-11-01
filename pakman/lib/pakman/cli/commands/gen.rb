# encoding: utf-8

module Pakman

class Gen

  include LogUtils::Logging

  include ManifestHelper

  def initialize( opts )
    @opts    = opts
  end

  attr_reader :opts

  def run( args )
    manifest_name = opts.manifest
    manifest_name = manifest_name.downcase.gsub('.txt', '' )  # remove .txt if present

    logger.debug "manifest=#{manifest_name}"

    # check for matching manifests
    manifests = installed_template_manifests.select { |m| m[0] == manifest_name+'.txt' }

    if manifests.empty?
      puts "*** error: unknown template pack '#{manifest_name}'; use pakman -l to list installed template packs"
      exit 2
    end

    manifestsrc = manifests[0][1]
    pakpath     = opts.output_path

    if args.empty?
      Copier.new.copy_pak( manifestsrc, pakpath )
    else
      args.each do |arg|
        data = YAML.load_file( arg )
        name = File.basename( arg, '.*' )
        puts "#{name}:"
        pp data
        Templater.new.merge_pak( manifestsrc, pakpath, Ctx.new(data).ctx, name )
      end
    end

  end

end # class Gen
end # module Pakman
