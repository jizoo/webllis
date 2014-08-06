class ConfirmingFormPresenter
  include HtmlBuilder

  attr_reader :form_builder, :view_context
  delegate :label, :hidden_field, :object, to: :form_builder

  def initialize(form_builder, view_context)
    @form_builder = form_builder
    @view_context = view_context
  end

  def text_field_block(name, label_text, options = {})
    markup(:div) do |m|
      m << decorated_label(name, label_text, options.merge(class: 'control-label'))
      if options[:disabled]
        m.div(object.send(name))
      else
        m.div(object.send(name))
        m << hidden_field(name, options)
      end
    end
  end

  def text_area_block(name, label_text, options = {})
    markup(:div, class: 'form-group') do |m|
      m << decorated_label(name, label_text, options.merge(class: 'control-label'))
      value = object.send(name)
      m.div do
        m << ERB::Util.html_escape(value).gsub(/\n/, '<br />')
      end
      m << hidden_field(name, options)
    end
  end

  def decorated_label(name, label_text, options = {})
    label(name, label_text)
  end
end
