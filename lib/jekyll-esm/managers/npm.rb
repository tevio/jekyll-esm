# frozen_string_literal: true


module Jekyll
  module Esm
    module Managers
      module Npm
        class Error < StandardError; end

        def self.location(config)
          config.dig('esm', 'npm', 'dir') || 'node_modules'
        end

        def self.dist(config)
          config.dig('esm', 'dist') || location(config) || 'node_modules'
        end

        def self.add(package:, site:)
          stdout, stderr, status = Open3.capture3(
            "npm install #{package}",
            chdir: File.expand_path(File.join(site.source, '/'))
          )

          if site.config.dig('esm', 'strict')
            runtime_error = stdout =~ /ERROR in|SyntaxError/

            raise Error, stderr if stderr.size > 0
            raise Error, stdout if !runtime_error.nil?
          end
        end

        def self.remove(packages:, site:)
          stdout, stderr, status = Open3.capture3(
            "npm uninstall #{packages}",
            chdir: File.expand_path(File.join(site.source, '/'))
          )

          if site.config.dig('esm', 'strict')
            runtime_error = stdout =~ /ERROR in|SyntaxError/

            raise Error, stderr if stderr.size > 0
            raise Error, stdout if !runtime_error.nil?
          end
        end
      end
    end
  end
end

