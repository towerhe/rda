group "backend" do
  guard :bundler do
    watch('Gemfile')
  end

  guard :rspec, version: 2, cli: '--color --format doc' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^spec/.+\.rb$}) { `say hello` }
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb') { "spec" }
  end
end
