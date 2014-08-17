module LoginHelper
  module Feature
    def login(user)
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end
  end

  module Controller
    def login(user)
      session[:user_id] = user.id
    end
  end
end
