class FormPresenter
  include HtmlBuilder

  attr_reader :form_builder, :view_context
  delegate :label, :text_field, :password_field, :check_box, :radio_button,
    :text_area, :url_field, :file_field, :hidden_field, :object, to: :form_builder

  def initialize(form_builder, view_context)
    @form_builder = form_builder
    @view_context = view_context
  end

  def notes
    markup(:div, class: 'notes') do |m|
      m.span '*'
      m.text '印の付いた項目は入力必須です。'
    end
  end

  def password_field_block(name, label_text)
    markup(:div, class: 'form-group') do |m|
      m << label(name, label_text, class: 'control-label')
      m << password_field(name, class: 'form-control')
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
      m << decorated_label(name, label_text, options.merge(class: 'control-label'))
      m << text_area(name, options.merge(class: 'form-control'))
    end
  end

  def check_boxes(name, label_text)
    markup(:div, class: 'checkbox') do |m|
      m << check_box(name)
      m << label(name, label_text)
    end
  end

  def decorated_label(name, label_text, options = {})
    label(name, label_text, class: options[:required] ? 'required' : nil)
  end
end
