module AllowedSourceHelper
  def ip_address(ip_address)
    [ ip_address.octet1, ip_address.octet2, ip_address.octet3, ip_address.wildcard? ? '*' : ip_address.octet4 ].join('.')
  end

  def ip_address_created_at(ip_address)
    ip_address.created_at.try(:strftime, '%Y/%m/%d %H:%M:%S')
  end
end
