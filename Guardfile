guard :rspec, cmd: 'bundle exec rspec' do
  watch('spec/spec_helper.rb')                        { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
end
