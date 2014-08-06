class ContactMailer < ActionMailer::Base
  default to: "jizoo2200@gmail.com"

  def send_message(contact)
    @contact = contact

    mail from: contact.email, subject: contact.subject
  end
end
