# Maintain your gem's version:
require_relative 'lib/acts_as_slugable/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name                  = 'acts_as_slugable'
  s.version               = Slugable::VERSION
  s.authors               = ['Arne De Herdt']
  s.email                 = ['arne.de.herdt@gmail.com']
  s.homepage              = ''
  s.summary               = 'Generates a URL slug based on specific fields of the model implementing this.'
  s.description           = 'Originally a Rails 2 plugin, this Gem ports that functionality to newer Rails versions.'
  s.license               = 'MIT'
  s.platform              = Gem::Platform::RUBY
  s.files                 = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files            = Dir['test/**/*']

  s.add_dependency 'rails'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'appraisal'
end
