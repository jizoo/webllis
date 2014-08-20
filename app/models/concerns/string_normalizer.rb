require 'nkf'

module StringNormalizer
  extend ActiveSupport::Concern

  def normalize(text)
    NKF.nkf('-w -Z1', text).strip if text
  end
end
