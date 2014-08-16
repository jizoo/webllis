5.times do |n|
  AllowedSource.create!(
    namespace: 'editor',
    ip_address: "192.168.0.#{n+1}"
  )
end
