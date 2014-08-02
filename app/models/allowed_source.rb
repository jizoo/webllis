class AllowedSource < ActiveRecord::Base
  validates :octet1, :octet2, :octet3, :octet4, presence: true,
    numericality: { only_integer: true, allow_blank: true },
    inclusion: { in: 0..255, allow_blank: true }
  validates :octet4,
    uniqueness: { scope: [ :octet1, :octet2, :octet3 ], allow_blank: true }

  def ip_address=(ip_address)
    octets = ip_address.split('.')
    self.octet1 = octets[0]
    self.octet2 = octets[1]
    self.octet3 = octets[2]
    if octets[3] == '*'
      self.octet4 = 0
      self.wildcard = true
    else
      self.octet4 = octets[3]
    end
  end

  class << self
    def include?(namespace, ip_address)
      !Rails.application.config.webllis[:restrict_ip_addresses] ||
        where(namespace: namespace).where(options_for(ip_address)).exists?
    end

    private
    def options_for(ip_address)
      octets = ip_address.split('.')
      condition = %Q{
        octet1 = ? AND octet2 = ? AND octet3 = ?
        AND ((octet4 = ? AND wildcard = ?) OR wildcard = ?)
      }.gsub(/\s+/, ' ').strip
      [ condition, *octets, false, true ]
    end
  end
end
