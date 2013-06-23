When 'I generate an engine called "$engine_name"' do |engine_name|
  template = File.expand_path(File.join('..', '..', 'template.rb'), File.dirname(__FILE__))
  run_simple "rails plugin new #{engine_name} --dummy-path=spec/dummy --skip-test-unit --mountable -m #{template}"
end