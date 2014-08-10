users = User.where(suspended: false).all
posts = @editor.posts

s = 2.years.ago
23.times do |n|
  m = Comment.create!(
    type: 'sent',
    creator: @editor,
    reader: users.sample,
    post: posts.sample,
    content: "これはコメントです。\n" * 8,
    created_at: s.advance(months: n)
  )
  r = Comment.create!(
    type: 'replied',
    creator: m.reader,
    reader: m.creator,
    post: m.post,
    root: m,
    parent: m,
    content: "これは返信です。\n" * 8,
    created_at: s.advance(months: n, hours: 1)
  )
  if n % 6 == 0
    m2 = Comment.create!(
      type: 'sent',
      creator: r.reader,
      reader: r.creator,
      post: r.post,
      root: m,
      parent: r,
      content: "これは返信への返信です。",
      created_at: s.advance(months: n, hours: 2)
    )
    Comment.create!(
      type: 'replied',
      creator: m2.reader,
      reader: m2.creator,
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
  Comment.create!(
    type: 'sent',
    creator: users.sample,
    reader: users.sample,
    post: posts.sample,
    content: "これはコメントです。\n" * 8,
    created_at: s.advance(hours: n * 3)
  )
end
