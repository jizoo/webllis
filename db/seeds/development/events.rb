users = User.all
256.times do |n|
  u = users.sample
  e = u.events.build
  if u.active?
    if n.even?
      e.type = 'logged_in'
    else
      e.type = 'logged_out'
    end
  else
    e.type = 'rejected'
  end
  e.occurred_at = (256 - n).hours.ago
  e.save!
end
