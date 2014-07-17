class FormPresenter
  include HtmlBuilder

  attr_reader :form_builder, :view_context
  delegate :label, :text_field, :password_field, :check_box, :radio_button,
    :text_area, :url_field, :file_field, :hidden_field, :object, to: :form_builder

  def initialize(form_builder, view_context)
    @form_builder = form_builder
    @view_context = view_context
  end

  def text_field_block(name, label_text)
    markup(:div, class: 'form-group') do |m|
      m << label(name, label_text, class: 'control-label')
      m << text_field(name, class: 'form-control')
    end
  end

  def password_field_block(name, label_text)
    markup(:div, class: 'form-group') do |m|
      m << label(name, label_text, class: 'control-label')
      m << password_field(name, class: 'form-control')
    end
  end
end
