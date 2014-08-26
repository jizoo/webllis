require 'rails_helper'

RSpec.describe User do
  describe 'テーブルの関係性' do
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:relationships).dependent(:destroy) }
    it { should have_many(:followed_users) }
    it { should have_many(:reverse_relationships).class_name('Relationship').dependent(:destroy) }
    it { should have_many(:followers) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorite_posts) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:authentications).dependent(:destroy) }
  end

  describe '値の正規化' do
    describe 'email' do
      it '前後の半角スペースを除去' do
        user = create(:user, email: ' test@example.com ')
        expect(user.email).to eq('test@example.com')
      end

      it '前後の全角スペースを除去' do
        user = create(:user, email: '　test@example.com　')
        expect(user.email).to eq('test@example.com')
      end

      it '全角英数字記号を半角に変換' do
        user = create(:user, email: 'ｔｅｓｔ＠ｅｘａｍｐｌｅ．ｃｏｍ')
        expect(user.email).to eq('test@example.com')
      end

      it '大文字を小文字に変換しemail_for_indexに格納すること' do
        user = create(:user, email: 'TEST＠EXAMPLE.COM')
        expect(user.email_for_index).to eq('test@example.com')
      end
    end

    describe 'name' do
      it '前後の半角スペースを除去' do
        user = create(:user, name: ' test ')
        expect(user.name).to eq('test')
      end

      it '前後の全角スペースを除去' do
        user = create(:user, name: '　test　')
        expect(user.name).to eq('test')
      end

      it '全角英数字記号を半角に変換' do
        user = create(:user, name: 'ｔｅｓｔ')
        expect(user.name).to eq('test')
      end
    end
  end

  describe 'バリデーション' do
    before { create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:name) }
    it { should ensure_length_of(:name).is_within(3..50) }
    it { should ensure_length_of(:password).is_within(6..20) }

    describe 'email' do
      it '「test@example.com」なら有効' do
        user = build(:user, email: 'test@example.com')
        expect(user).to be_valid
      end

      it 'ハイフン「-」を含むなら有効' do
        user = build(:user, email: 'info-test@example.com')
        expect(user).to be_valid
      end

      it 'プラス「＋」を含むなら有効' do
        user = build(:user, email: 'info+test@example.com')
        expect(user).to be_valid
      end

      it "クオート「'」を含むなら有効" do
        user = build(:user, email: "infotest@example.com")
        expect(user).to be_valid
      end

      it 'アット「@」を2個含むなら無効' do
        user = build(:user, email: 'test@@example.com')
        expect(user).to be_invalid
      end

      it '先頭が「mailto:」なら無効' do
        user = build(:user, email: 'mailto:test@@example.com')
        expect(user).to be_invalid
      end

      it '途中のスペースを含むなら無効' do
        user = build(:user, email: 'te st@example.com')
        expect(user).to be_invalid
      end
    end

    describe 'name' do
      it '大文字を含むなら有効' do
        user = build(:user, name: 'Test')
        expect(user).to be_valid
      end

      it '数字を含むなら有効' do
        user = build(:user, name: 'test1')
        expect(user).to be_valid
      end

      it 'アンダースコア「_」を含むなら有効' do
        user = build(:user, name: 'test_user')
        expect(user).to be_valid
      end

      it 'ハイフン「-」を含むなら無効' do
        user = build(:user, name: 'test-user')
        expect(user).to be_invalid
      end

      it '記号を含むなら無効' do
        user = build(:user, name: 'test☆')
        expect(user).to be_invalid
      end

      it '日本語を含むなら無効' do
        user = build(:user, name: 'テスト')
        expect(user).to be_invalid
      end

      it '途中にスペースを含むなら無効' do
        user = build(:user, name: 'te st')
        expect(user).to be_invalid
      end
    end

    describe 'password' do
      it 'password_confirmationと一致するなら有効' do
        user = build(:user, password_confirmation: 'password')
        expect(user).to be_valid
      end

      it 'password_confirmationと一致しないなら無効' do
        user = build(:user, password_confirmation: 'mismatch')
        expect(user).to be_invalid
      end

      context 'authenticationsが存在する場合' do
        it 'バリデーションをスキップする'
      end

      context 'authenticationsが存在しない場合' do
        it 'バリデーションを行う' 
      end
    end
  end

  describe '#password' do
    context '文字列を与えた場合' do
      it 'hashed_passwordは長さ60の文字列になること' do
        user = build(:user, password: 'password')
        expect(user.hashed_password).to be_kind_of(String)

        expect(user.hashed_password.size).to eq(60)
      end
    end

    context 'nilを与えた場合' do
      it 'hashed_passwordはnilになること' do
        user = build(:user, hashed_password: nil)
        expect(user.hashed_password).to be_nil
      end
    end
  end

  describe '#add_favorite' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    before do
      user.add_favorite!(post)
    end

    it 'userとpostの関係が作成されること' do
      expect(user.favorite_posts).to be_include(post)
    end

    context 'ユーザが削除された場合' do
      it 'userとpostの関係は削除されること' do
        user.destroy
        expect(Favorite.where(user: user, post: post)).to be_empty
      end
    end

    context '投稿が削除された場合' do
      it 'userとpostの関係は削除されること' do
        post.destroy
        expect(Favorite.where(user: user, post: post)).to be_empty
      end
    end
  end

  describe '#remove_favorite' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    before do
      Favorite.create!(user: user, post: post)
      user.remove_favorite!(post)
    end

    it 'userとpostの関係が解除されること' do
      expect(user.favorite_posts).not_to be_include(post)
    end
  end
end
