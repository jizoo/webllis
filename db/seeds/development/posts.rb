dummy_text = 'この文章はダミーです。'

30.times do |p|
  users = User.limit(5)
  users.each do |user|
      user.posts.create!(
      url: "http://example#{p+1}.com",
      title: "タイトル#{p+1}",
      description: "#{dummy_text*20}",
      image: open("#{Rails.root}/db/fixtures/images/thumbnail.gif")
    )
  end
end
