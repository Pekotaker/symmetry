# Create default admin user
admin = User.find_or_initialize_by(email: 'admin@gmail.com')

if admin.new_record?
  admin.assign_attributes(
    first_name: 'Admin',
    last_name: 'User',
    password: 'Password123!',
    password_confirmation: 'Password123!',
    admin: true
  )
  admin.skip_confirmation!
  admin.save!
  puts "✓ Admin user created: admin@gmail.com (admin: true)"
else
  # Ensure existing admin user has admin privileges
  unless admin.admin?
    admin.update!(admin: true)
    puts "✓ Admin privileges granted to: admin@gmail.com"
  else
    puts "→ Admin user already exists: admin@gmail.com"
  end
end

# Load additional seed files
Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |seed_file|
  load seed_file
end
