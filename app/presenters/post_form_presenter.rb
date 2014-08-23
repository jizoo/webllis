class PostFormPresenter < FormPresenter
  delegate :image_tag, to: :view_context
  delegate :image, to: :object

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
end
