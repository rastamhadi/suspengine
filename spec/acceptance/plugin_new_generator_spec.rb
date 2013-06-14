require 'rails/generators'
require 'rails/generators/rails/plugin_new/plugin_new_generator'

describe Rails::Generators::PluginNewGenerator do
  describe '.start' do
    before do
      FileUtils.rm_rf(destination_root)
      Rails::Generators::PluginNewGenerator.start([engine_path, '--skip-test-unit', '--mountable', '-m', template_path])
    end

    it 'customizes the engine' do
      # sets the gemspec encoding to UTF-8
      expect(gemspec.readline).to match /#.*coding: utf-8/
      # removes the MIT license
      expect(File.exists?(license_path)).to be_false
      expect(gemspec_contents).to_not match /MIT-LICENSE/
      # installs squeel
      expect(gemspec_contents).to match /add_dependency 'squeel'/
      expect(engine_module).to match /require 'squeel'/
      # uses Markdown for README
      expect(File.exists?("#{readme_path}.rdoc")).to be_false
      expect(File.exists?("#{readme_path}.md")).to be_true
      expect(gemspec_contents).to_not match /README\.rdoc/
      expect(gemspec_contents).to match /README\.md/
      # sets up TDD environment
      expect(gemspec_contents).to match /add_development_dependency 'rspec-rails'/
      expect(gemspec_contents).to match /add_development_dependency 'factory_girl_rails'/
      expect(gemspec_contents).to match /add_development_dependency 'guard-rspec'/
      expect(gemspec_contents).to match /add_development_dependency 'wdm'/
      expect(engine_class).to match /test_framework :rspec, :fixture => false/
      expect(engine_class).to match %r(fixture_replacement :factory_girl, :dir => 'spec/factories')
      expect(engine_class).to match /assets false/
      expect(engine_class).to match /helper false/
    end

    private

    def gemspec
      @gemspec ||= File.new(gemspec_path)
    end

    def gemspec_contents
      @gemspec_contents ||= File.binread(gemspec_path)
    end

    def engine_class
      @engine_class ||= File.binread(File.join(library_path, engine_name, 'engine.rb'))
    end

    def engine_module
      @engine_module ||= File.binread(File.join(library_path, "#{engine_name}.rb"))
    end

    def library_path
      @library_path ||= File.join(engine_path, 'lib')
    end

    def readme_path
      @readme_path ||= File.join(engine_path, 'README')
    end

    def gemspec_path
      @gemspec_path ||= File.join(engine_path, "#{engine_name}.gemspec")
    end

    def license_path
      @license_path ||= File.join(engine_path, 'MIT-LICENSE')
    end

    def engine_path
      @engine_path ||= File.join(destination_root, engine_name)
    end

    def engine_name
      @engine_name ||= 'my_engine'
    end

    def template_path
      @template_path ||= File.expand_path('template.rb')
    end

    def destination_root
      @destination_root ||= File.join(File.dirname(__FILE__), 'sandbox')
    end
  end
end