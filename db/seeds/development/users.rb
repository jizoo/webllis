100.times do |n|
  User.create!(
    name: "example#{n+1}",
    email: "example#{n+1}@example.com",
    password: 'password'
  )
end
