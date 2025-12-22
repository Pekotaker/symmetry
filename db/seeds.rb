# Create default admin user
admin = User.find_or_initialize_by(email: 'admin@gmail.com')

if admin.new_record?
  admin.assign_attributes(
    first_name: 'Admin',
    last_name: 'User',
    password: 'Password123!',
    password_confirmation: 'Password123!'
  )
  admin.skip_confirmation!
  admin.save!
  puts "✓ Admin user created: admin@gmail.com"
else
  puts "→ Admin user already exists: admin@gmail.com"
end
