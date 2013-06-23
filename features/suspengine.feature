@disable-bundler
Feature: Generating a Rails Engine

  Scenario: Encoding the gemspec with UTF-8
    When I generate an engine called "my_engine"
    Then the file "my_engine/my_engine.gemspec" should match /#.*coding: utf-8/

  Scenario: Removing the MIT License
    When I generate an engine called "my_engine"
    Then the file "my_engine/MIT-LICENSE" should not exist
    And the file "my_engine/my_engine.gemspec" should not contain "MIT-LICENSE"

  Scenario: Installing squeel
    When I generate an engine called "my_engine"
    Then the file "my_engine/my_engine.gemspec" should contain "add_dependency 'squeel'"
    And the file "my_engine/lib/my_engine.rb" should contain "require 'squeel'"

  Scenario: Using Markdown for README
    When I generate an engine called "my_engine"
    Then the file "my_engine/README.rdoc" should not exist
    And a file named "my_engine/README.md" should exist
    And the file "my_engine/my_engine.gemspec" should not contain "README.rdoc"
    And the file "my_engine/my_engine.gemspec" should contain "README.md"

  Scenario: Installing TDD gems
    When I generate an engine called "my_engine"
    Then the file "my_engine/my_engine.gemspec" should contain "add_development_dependency 'rspec-rails'"
    And the file "my_engine/my_engine.gemspec" should contain "add_development_dependency 'factory_girl_rails'"
    And the file "my_engine/my_engine.gemspec" should contain "add_development_dependency 'guard-rspec'"
    And the file "my_engine/my_engine.gemspec" should contain "add_development_dependency 'wdm'"

  Scenario: Customizing Rails generators
    When I generate an engine called "my_engine"
    Then the file "my_engine/lib/my_engine/engine.rb" should contain "test_framework :rspec, :fixture => false"
    And the file "my_engine/lib/my_engine/engine.rb" should contain "fixture_replacement :factory_girl, :dir => 'spec/factories'"
    And the file "my_engine/lib/my_engine/engine.rb" should contain "assets false"
    And the file "my_engine/lib/my_engine/engine.rb" should contain "helper false"