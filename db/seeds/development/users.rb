image_colors = %w(2ecc71 3498db 9b59b6 f1c40f e74c3c)

100.times do |n|
  u = User.create!(
    name: "example#{n+1}",
    email: "example#{n+1}@example.com",
    password: 'password',
    password_confirmation: 'password',
  )
  30.times do |p|
    u.posts.create!(
      url: "http://example#{p+1}.com",
      title: "タイトル#{p+1}",
      description: 'この文章はダミーです。',
      remote_image_url: "http://placehold.it/300x200/#{image_colors.sample}/ffffff",
    )
  end
end
