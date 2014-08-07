users = User.where(suspended: false).all
posts = @editor.posts

s = 2.years.ago
23.times do |n|
  m = OutboundComment.create!(
    user: users.sample,
    post: posts.sample,
    content: "これはコメントです。\n" * 8,
    created_at: s.advance(months: n)
  )
  r = InboundComment.create!(
    user: m.user,
    post: m.post,
    root: m,
    parent: m,
    content: "これは返信です。\n" * 8,
    created_at: s.advance(months: n, hours: 1)
  )
  if n % 6 == 0
    m2 = OutboundComment.create!(
      user: r.user,
      post: r.post,
      root: m,
      parent: r,
      content: "これは返信への返信です。",
      created_at: s.advance(months: n, hours: 2)
    )
    InboundComment.create!(
      user: m2.user,
      post: r.post,
      root: m,
      parent: m2,
      content: "これは返信の返信への返信です。",
      created_at: s.advance(months: n, hours: 3)
    )
  end
end

s = 24.hours.ago
8.times do |n|
  OutboundComment.create!(
    user: users.sample,
    post: posts.sample,
    content: "これはコメントです。\n" * 8,
    created_at: s.advance(hours: n * 3)
  )
end
