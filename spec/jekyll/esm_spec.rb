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

  describe "building the site" do
    context 'when esm finds a module' do
      before do
        FileUtils.rm_rf("#{SPEC_FIXTURES_DIR}/node_modules")
        site.reset
        site.read
        (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
        site.render
      end

      it "writes the output" do
        site.write

        p "first run written"
        expect(Dir.exists?("#{SPEC_FIXTURES_DIR}/_site/node_modules/stimulus")).to be(true)
        expect(Dir.exists?("#{SPEC_FIXTURES_DIR}/_site/node_modules/turbolinks")).to be(true)
        expect(Dir.exists?("#{SPEC_FIXTURES_DIR}/_site/node_modules/turbolinks-animate")).to be(true)

        FileUtils.mv("#{SPEC_FIXTURES_DIR}/_layouts/default.html", "#{SPEC_FIXTURES_DIR}/_layouts/default.html.tmp_off")
        FileUtils.mv("#{SPEC_FIXTURES_DIR}/_layouts/default.html.off", "#{SPEC_FIXTURES_DIR}/_layouts/default.html")

        site.reset
        site.read
        (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
        site.render
        site.write

        p "Second run written"
        FileUtils.mv("#{SPEC_FIXTURES_DIR}/_layouts/default.html", "#{SPEC_FIXTURES_DIR}/_layouts/default.html.off")
        FileUtils.mv("#{SPEC_FIXTURES_DIR}/_layouts/default.html.tmp_off", "#{SPEC_FIXTURES_DIR}/_layouts/default.html")


        expect(Dir.exists?("#{SPEC_FIXTURES_DIR}/_site/node_modules/stimulus")).to be(true)
        expect(Dir.exists?("#{SPEC_FIXTURES_DIR}/_site/node_modules/turbolinks")).to be(false)
        expect(Dir.exists?("#{SPEC_FIXTURES_DIR}/_site/node_modules/turbolinks-animate")).to be(false)
        expect(Dir.exists?("#{SPEC_FIXTURES_DIR}/_site/node_modules/@hotwired/turbo")).to be(true)

        FileUtils.rm_rf("#{SPEC_FIXTURES_DIR}/node_modules")
      end
    end
  end
end
