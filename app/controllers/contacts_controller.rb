class ContactsController < Base
  skip_before_action :authorize

  def new
    @contact = ContactForm.new
  end

  def confirm
    @contact = ContactForm.new(contact_params)
    if @contact.valid?
      render action: 'confirm'
    else
      flash.now[:danger] = '入力に誤りがあります。'
      render action: 'new'
    end
  end

  def create
    @contact = ContactForm.new(contact_params)
    if params[:commit]
      if ContactMailer.send_message(@contact).deliver
        flash[:success] = '問い合わせを送信しました。'
        redirect_to :root
      else
        flash.now[:danger] = '入力に誤りがあります。'
        render action: 'new'
      end
    else
      render action: 'new'
    end
  end

  private
  def contact_params
    params.require(:contact_form).permit(
      :name, :email, :subject, :body
    )
  end
end
