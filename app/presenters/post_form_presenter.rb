class PostFormPresenter < FormPresenter
  def url_field_block(name, label_text)
    markup(:div, class: 'form-group') do |m|
      m << label(name, label_text, class: 'control-label')
      m << url_field(name, class: 'form-control')
    end
  end

  def text_area_block(name, label_text, options = {})
    markup(:div, class: 'form-group') do |m|
      m << label(name, label_text, class: 'control-label')
      m << text_area(name, options.merge(class: 'form-control'))
    end
  end
end
