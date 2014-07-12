shared_examples 'a protected user controller' do
  describe '#index' do
    example 'ログインフォームにリダイレクト' do
      get :index
      expect(response).to redirect_to(login_url)
    end
  end

  describe '#edit' do
    example 'ログインフォームにリダイレクト' do
      get :edit, id: 1
      expect(response).to redirect_to(login_url)
    end
  end
end

