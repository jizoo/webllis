shared_examples 'Authenticationの作成' do
  it '引数で設定した属性が返ること' do
    expect(authentication.provider).to eq 'twitter'
    expect(authentication.uid).to eq 'uid'
    expect(authentication.nickname).to eq 'jizoo'
    expect(authentication.image).to eq 'http://example.com/jizoo.jpg'
  end
end
