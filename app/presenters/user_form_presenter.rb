class UserFormPresenter < FormPresenter
  def password_field_block(name, label_text, options = {})
    if object.new_record?
      super(name, label_text)
    else
      markup(:div, class: 'form-group') do |m|
        m << label(name, label_text, class: 'control-label')
        m << password_field(name, options.merge(disabled: true, class: 'form-control'))
        m.button('変更する', type: 'button', id: 'enable-password-field', class: 'btn btn-link')
        m.button('変更しない', type: 'button', id: 'disable-password-field',
          style: 'display: none', class: 'btn btn-link')
      end
    end
  end

  def check_boxes
    markup(:div, class: 'checkbox') do |m|
      m << check_box(:suspended)
      m << label(:suspended, 'アカウント停止')
    end
  end
end
