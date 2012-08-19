# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spin' do
  watch(%r{^spec/.+_spec\.rb$})

  # Rails
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/views/(.+)/.+\.erb$})                 { |m| "spec/requests/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| "spec/requests/#{m[1]}_spec.rb" }
  watch('app/controllers/application_controller.rb')  { "spec/requests" }
end
