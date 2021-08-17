# frozen_string_literal: true

require "jekyll/esm/version"
require "jekyll"
require "open3"
require 'tmpdir'
require 'nokogiri'
require 'json'

module Jekyll
  module Esm
    class Error < StandardError; end

    def self.process(page)
      doc = Nokogiri::HTML(page.output)

      import_maps = doc.search('script[type=importmap]')

      import_maps.each do |value|
        importmap = JSON.parse(value.children[0].content)
        imports = importmap["imports"]
        imports.keys.each do |import|

          stdout, stderr, status = Open3.capture3(
            "yarn add #{import}",
            chdir: File.expand_path(page.site.source)
          )

          if page.site.config.dig('esm', 'strict')
            runtime_error = stdout =~ /ERROR in|SyntaxError/

            raise Error, stderr if stderr.size > 0
            raise Error, stdout if !runtime_error.nil?
          end
        end
      end

    end

    def self.apply(site)
      FileUtils.cp_r(File.join(site.source, 'node_modules'), File.join(site.dest, 'node_modules'))
    end

    private

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
