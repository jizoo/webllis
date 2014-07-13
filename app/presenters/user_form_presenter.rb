class UserFormPresenter < FormPresenter
  def check_boxes
    markup(:div, class: 'checkbox') do |m|
      m << check_box(:suspended)
      m << label(:suspended, 'アカウント停止')
    end
  end
end
