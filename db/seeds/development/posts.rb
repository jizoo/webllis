image_colors = %w(blue green purpul red yellow)

30.times do |p|
  users = User.limit(5)
  users.each do |user|
      user.posts.create!(
      url: "http://example#{p+1}.com",
      title: "タイトル#{p+1}",
      description: 'この文章はダミーです。',
      image: open("#{Rails.root}/db/fixtures/images/#{image_colors.sample}.gif")
    )
  end
end
