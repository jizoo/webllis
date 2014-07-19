posts = Post.all
user = User.first
favorite_posts = posts[2..30]
favorite_posts.each { |other_post| user.add_favorite!(other_post) }
