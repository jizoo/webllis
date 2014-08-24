module UserHelper
  # ユーザの停止フラグのOn/Offを表現する記号を返す。
  #   On: BALLOT BOX WITH CHECK (U+2611)
  #   Off: BALLOT BOX (U+2610)
  def check_mark(name)
    name ? raw('&#x2611;') : raw('&#x2610;')
  end
end
