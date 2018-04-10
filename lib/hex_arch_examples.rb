require 'ostruct'

Dir[File.join(__dir__, 'entities/**/*.rb')].each do |file|
  require file
end

require 'persistence/repository'

Dir[File.join(__dir__, 'persistence/**/*.rb')].each do |file|
  require file
end

require 'services/responses/base'

Dir[File.join(__dir__, 'services/responses/**/*.rb')].each do |file|
  require file
end

require 'services/base'
require 'services/sessionable_service'

# Dir[] does not guarantee the order in which files will be listed.
Dir[File.join(__dir__, 'services/**/*.rb')].each do |file|
  require file
end
