# frozen_string_literal: true

RSpec.describe Jekyll::Esm do
  Jekyll.logger.log_level = :error

  SPEC_FIXTURES_DIR = File.expand_path("../fixtures", __dir__)

  let(:config_overrides) { {} }
  let(:configs) do
    Jekyll.configuration(
      config_overrides.merge(
        "skip_config_files" => false,
        "collections"       => { "docs" => { "output" => true } },
        "source"            => fixtures_dir,
        "destination"       => fixtures_dir("_site")
      )
    )
  end

  let(:site)      { Jekyll::Site.new(configs) }
  let(:cleaner)   { Jekyll::Cleaner.new(configs) }
  let(:posts)     { site.posts.docs.sort.reverse }

  after(:each) do
    if Dir.exists?("#{SPEC_FIXTURES_DIR}/dist")
      FileUtils.rm_rf("#{SPEC_FIXTURES_DIR}/dist")
    end

    if Dir.exists?("#{SPEC_FIXTURES_DIR}/_site")
      FileUtils.rm_rf("#{SPEC_FIXTURES_DIR}/_site")
    end
  end

  it "has a version number" do
    expect(Jekyll::Esm::VERSION).not_to be nil
  end

  let(:bad_js_src_off) { "#{SPEC_FIXTURES_DIR}/src/controllers/hello_controller.syntax.js.off" }
  let(:bad_js_src_on) { "#{SPEC_FIXTURES_DIR}/src/controllers/hello_controller.syntax.js" }

  let(:bad_js_dest_off) { "#{SPEC_FIXTURES_DIR}/_site/src/controllers/hello_controller.syntax.js.off" }
  let(:bad_js_dest_on) { "#{SPEC_FIXTURES_DIR}/_site/src/controllers/hello_controller.syntax.js" }

  describe "building the site" do
    context 'when esm finds a module' do
      before do
        if File.exists?(bad_js_src_on)
          File.delete(bad_js_src_on)
        end

        if File.exists?(bad_js_dest_on)
          File.delete(bad_js_dest_on)
        end

        site.reset
        site.read
        (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
        site.render
      end

      it "writes the output" do
        site.write
        expect(Dir.exists?("#{SPEC_FIXTURES_DIR}/_site/node_modules/lodash")).to be(true)
      end
    end
  end
end
