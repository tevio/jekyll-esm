# frozen_string_literal: true

require "jekyll-esm/version"
require "jekyll-esm/managers/yarn"
require "jekyll-esm/managers/npm"
require "jekyll-esm/managers/bower"
require "jekyll"
require "open3"
require 'tmpdir'
require 'nokogiri'
require 'json'

module Jekyll
  module Esm
    @@existing_esm_packages = []
    @@new_esm_packages = []
    @@esm_ids = []

    class Error < StandardError; end

    def self.process(page)
      site = page.site
      manager = select_manager(site.config.dig('esm', 'manager'))
      location = manager.location(site.config)

      doc = Nokogiri::HTML(page.output)

      import_maps = doc.search('script[type=importmap]')

      import_maps.each do |value|
        esm_id = value.attributes["data-esm-id"]&.value
        # declare a data-esm-id so that jekyll will only process an esm declaration once
        next if @@esm_ids.include?(esm_id)
        @@esm_ids << esm_id if esm_id

        importmap = JSON.parse(value.children[0].content)
        imports = importmap["imports"]
        imports.keys.each do |import_key|
          # ignore urls
          next if import_key =~ /https?:\/\/[\S]+/
          next if imports[import_key] =~ /https?:\/\/[\S]+/
          # ignore relative paths
          next if import_key =~ /(^\.+\/)+/
          # ignore absolute paths
          next if import_key =~ /^\/[\S]+/

          # ignore namespaces but only if it is not scoped
          if import_key =~ /^@[\S]+/
            import = import_key.split('/')[0..1].join('/')
          else
            import = import_key.split('/').first
          end

          pkg_path = File.join(site.source, location, import)

          # don't repeatedly attempt to install a package
          next if Dir.exists?(pkg_path) && @@new_esm_packages.include?(import)

          @@new_esm_packages << import

          manager.add(package: import, site: site)

        end
      end
    end

    def self.select_manager(name)
      return Managers::Npm if name == 'npm'
      return Managers::Bower if name == 'bower'
      return Managers::Yarn
    end

    def self.apply(site)
      manager = select_manager(site.config.dig('esm', 'manager'))
      location = manager.location(site.config)
      dist = manager.dist(site.config)

      if @@existing_esm_packages.any?
        for_removal = @@existing_esm_packages - @@new_esm_packages.uniq

        # Remove any packages that are no longer referenced in an esm declaration
        if for_removal.any?
          packages = for_removal.join(' ')
          manager.remove(packages: packages, site: site)
        end
      end

      return unless Dir.exists?(File.join(site.source, location))

      FileUtils.rm_rf(File.join(site.dest, dist))
      FileUtils.cp_r(File.join(site.source, location), File.join(site.dest, dist))
      @@existing_esm_packages = @@new_esm_packages
      @@new_esm_packages = []
      @@esm_ids = []
    end
  end
end


Jekyll::Hooks.register :pages, :post_render do |page|
  Jekyll::Esm.process(page)
end

Jekyll::Hooks.register :documents, :post_render do |page|
  Jekyll::Esm.process(page)
end

Jekyll::Hooks.register :posts, :post_render do |page|
  Jekyll::Esm.process(page)
end

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll::Esm.apply(site)
end
