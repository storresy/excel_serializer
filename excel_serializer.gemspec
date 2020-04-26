require_relative 'lib/excel_serializer/version'

Gem::Specification.new do |spec|
  spec.name          = "excel_serializer"
  spec.version       = ExcelSerializer::VERSION
  spec.authors       = ["Sebastian Torres"]

  spec.summary       = %q{An excel serializer for Ruby objects}
  spec.description   = %q{This gem allows you to easily export ruby objects to excel files by defining a serializer for each object. ExcelSerializer can work with multiple excel writting gems and allows you to translate the document headers using I18n.}
  spec.homepage      = "https://github.com/storresy/excel_serializer"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/storresy/excel_serializer"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
