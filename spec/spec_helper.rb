spec = Gem::Specification.find_by_name("geotab")

require "#{spec.gem_dir}/lib/geotab.rb"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "#{spec.gem_dir}/spec/vcr"
  c.hook_into :fakeweb

  c.filter_sensitive_data('<username>') { "username" }
  c.filter_sensitive_data('<password>') { "password" }
  c.filter_sensitive_data('<database>') { "database" }
  c.filter_sensitive_data('<sessionId>') { "sessionId" }
end