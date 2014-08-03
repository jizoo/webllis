@editor = User.create!(
  name: 'jizoo',
  email: 'jizoo2200@gmail.com',
  password: 'foobar',
  icon_image: 'https://secure.gravatar.com/avatar?s=50',
  editor: true
)

User.create!(
  name: 'admin',
  email: 'admin@example.com',
  password: 'foobar',
  icon_image: 'https://secure.gravatar.com/avatar?s=50',
  admin: true
)

100.times do |n|
  User.create!(
    name: "example#{n+1}",
    email: "example#{n+1}@example.com",
    password: 'password',
    icon_image: "https://secure.gravatar.com/avatar?s=50"
  )
end
