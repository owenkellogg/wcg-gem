Gem::Specification.new do |s|
  s.name        = 'wcg'
  s.version     = '0.0.1'
  s.date        = '2013-12-05'
  s.summary     = "Interact with the World Community Grid"
  s.description = "An abstraction over the World Community Grid XML APIs"
  s.authors     = ["Steven Zeiler"]
  s.email       = 'zeiler.steven@gmail.com'
  s.files       = ["lib/wcg.rb", "lib/wcg/api.rb", "lib/wcg/team_member.rb", "lib/wcg/team.rb"]
  s.license       = 'MIT'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'httparty'
end