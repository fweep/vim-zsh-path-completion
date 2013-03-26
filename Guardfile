guard 'spork', cucumber: false do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'rspec' do
  watch('spec/spec_helper.rb') { "spec" }
  watch(%r{^plugin/.+\.vim$}) { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
end
