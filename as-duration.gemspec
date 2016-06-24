Gem::Specification.new do |spec|
  spec.name         = "as-duration"
  spec.version      = "0.1.1"
  spec.authors      = ["Janko Marohnić"]
  spec.email        = ["janko.marohnic@gmail.com"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.summary      = "Extraction of ActiveSupport::Duration and the related core extensions."
  spec.description  = spec.summary
  spec.homepage     = "https://github.com/janko-m/as-duration"
  spec.license      = "MIT"

  spec.files        = Dir["README.md", "LICENSE.txt", "lib/**/*", "*.gemspec"]
  spec.require_path = "lib"

  spec.add_development_dependency "minitest", "5.6.0"
  spec.add_development_dependency "rake"
end
