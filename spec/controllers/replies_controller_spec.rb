require 'rails_helper'

describe RepliesController do
  let(:user) { create(:user) }
  let(:user_post) { create(:post) }
  let(:comment) { create(:comment) }

  describe 'GET #new' do
    context '未ログインユーザがアクセスしたとき' do
      before { get :new, post_id: user_post.id, comment_id: comment.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスしたとき' do
      before do
        login(user)
        get :new, post_id: user_post.id, comment_id: comment.id
      end

      it 'ステータスコードとして200が返ること' do
        expect(response.status).to eq(200)
      end

      it '@replyに、新規Commentオブジェクトが格納されていること' do
        expect(assigns(:reply)).to be_a_new(Comment)
      end

      it 'newテンプレートをrenderしていること' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #confirm' do
    # TODO
  end

  describe 'POST #create' do
    # TODO
  end
end
