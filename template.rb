indentation = "\n  "
gemspec = "#{name}.gemspec"
gem_module = File.join('lib', "#{name}.rb")
engine_class = File.join('lib', name, 'engine.rb')

prepend_to_file gemspec, "# encoding: utf-8\n"
gsub_file gemspec, '"MIT-LICENSE", ', ''
remove_file 'MIT-LICENSE'
copy_file 'README.rdoc', 'README.md'
remove_file 'README.rdoc'
gsub_file gemspec, 'rdoc', 'md'
insert_into_file gem_module, :after => "module #{name.camelize}" do
  "#{indentation}require 'squeel'"
end
insert_into_file engine_class, :after => "isolate_namespace #{name.camelize}" do
  generator_customizations = [
    'config.generators do |g|',
    '  g.test_framework :rspec, :fixture => false',
    "  g.fixture_replacement :factory_girl, :dir => 'spec/factories'",
    '  g.assets false',
    '  g.helper false',
    'end'
  ]
  "#{indentation}  " + generator_customizations.join("#{indentation}  ")
end
insert_into_file gemspec, :before => "#{indentation}s.add_development_dependency" do
  gems = [
    "'rspec-rails'",
    "'guard-rspec'",
    "'factory_girl_rails', '~> 4.0'",
    "'wdm', '>= 0.1.0' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i"
  ]
  dependencies = ["s.add_dependency 'squeel'"]
  development_dependencies = gems.map { |gem| "s.add_development_dependency #{gem}" }
  indentation + (dependencies + development_dependencies).join(indentation)
end