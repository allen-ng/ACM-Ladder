# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

puts "Creating roles..."
["admin", "user"].each do |role|
  Role.find_or_create_by(name: role)
  puts "\tCreated role: " << role
end

puts "Creating default admin account..."
user = User.create(:handle => ENV['ADMIN_HANDLE'].dup,
                                     :email => ENV['ADMIN_EMAIL'].dup,
                                     :password => ENV['ADMIN_PASSWORD'].dup,
                                     :password_confirmation => ENV['ADMIN_PASSWORD'].dup)
user.add_role :admin
user.remove_role :user
puts "Created admin: " << user.handle

puts "Initializing default configurations..."
puts "\tMAX_LEVEL => 0"
Setting.find_or_create_by(:key => "MAX_LEVEL", :value => 0)
puts "\t\tEXP_L0 => 0"
Setting.find_or_create_by(:key => "EXP_L0", :value => 0)
puts "\tMAX_DIFFICULTY => 0"
Setting.find_or_create_by(:key => "MAX_DIFFICULTY", :value => 0)
puts "\tSHOW_ANNOUNCEMENT => 0"
Setting.find_or_create_by(:key => "SHOW_ANNOUNCEMENT", :value => 0)
puts "\tANNOUNCEMENT => \"\""
Setting.find_or_create_by(:key => "ANNOUNCEMENT", :value => "")
