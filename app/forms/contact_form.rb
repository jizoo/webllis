class ContactForm
  include ActiveModel::Model

  attr_accessor :email, :name, :subject, :body
end
