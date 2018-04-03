# Load Base classes first
# Dir[] does not guarantee the order in which those files will be listed.
Dir[File.join(__dir__, 'services/*base.rb')].each do |file|
  require file
end

Dir[File.join(__dir__, 'services/*.rb')].each do |file|
  require file
end
