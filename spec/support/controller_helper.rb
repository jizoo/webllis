shared_examples '認証が必要なページ' do
  it 'ログインページにリダイレクトすること' do
    expect(response).to redirect_to(login_path)
  end
end
