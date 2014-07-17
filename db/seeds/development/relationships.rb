users = User.all
user  = users.first
followed_users = users[2..50]
followers      = users[3..40]
followed_users.each { |followed| user.follow!(followed) }
followers.each      { |follower| follower.follow!(user) }
