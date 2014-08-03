class PostFormPresenter < FormPresenter
  delegate :image_tag, to: :view_context
  delegate :image, to: :object

  def notes
    markup(:div, class: 'notes') do |m|
      m.span '*'
      m.text '印の付いた項目は入力必須です。'
    end
  end

  def url_field_block(name, label_text, options = {})
    markup(:div, class: 'form-group') do |m|
      m << decorated_label(name, label_text, options.merge(class: 'control-label'))
      m << url_field(name, options.merge(class: 'form-control'))
    end
  end

  def text_field_block(name, label_text, options = {})
    markup(:div, class: 'form-group') do |m|
      m << decorated_label(name, label_text, options.merge(class: 'control-label'))
      m << text_field(name, options.merge(class: 'form-control'))
    end
  end

  def text_area_block(name, label_text, options = {})
    markup(:div, class: 'form-group') do |m|
      m << label(name, label_text, class: 'control-label')
      m << text_area(name, options.merge(class: 'form-control'))
    end
  end

  def image_field_block(name, label_text)
    markup(:div, class: 'form-group') do |m|
      if object.image?
        m.div(class: 'thumbnail') do
          m << image_tag(object.image.url)
        end
      end
      m << label(name, label_text, class: 'control-label')
      m << file_field(name)
      m << hidden_field("#{name}_cache")
      if object.persisted?
        m.div(class: 'checkbox') do
          m << check_box("remove_#{name}")
          m << label("remove_#{name}", '削除する')
        end
      end
    end
  end

  def tag_field_block(name, label_text)
    markup(:div, class: 'form-group') do |m|
      m << label(name, label_text, class: 'control-label')
      m << text_field(name, class: 'form-control')
    end
  end

  def decorated_label(name, label_text, options = {})
    label(name, label_text, class: options[:required] ? 'required' : nil)
  end
end
