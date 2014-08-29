require 'rails_helper'

describe FavoritesController do
  let(:user) { create(:user) }
  let(:other_post) { create(:post) }

  describe 'POST #create' do
    context '未ログインユーザがアクセスした場合' do
      before { xhr :post, :create, favorite: { post_id: other_post.id } }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before { login(user) }

        it 'Favoriteレコードが1件増えること' do
          expect { xhr :post, :create, favorite: { post_id: other_post.id } }.
            to change { Favorite.count }.by(1)
        end

        it 'ステータスコード200を返すこと' do
          xhr :post, :create, favorite: { post_id: other_post.id }
          expect(response).to be_success
          expect(response.status).to eq(200)
        end
    end
  end

  describe 'DELETE #destroy' do
    context '未ログインユーザがアクセスした場合' do
      before do
        xhr :delete, :destroy, id: other_post.id
      end

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      let(:favorite) { user.favorites.find_by(post_id: other_post.id) }

      before do
        user.add_favorite!(other_post)
        login(user)
      end

      it 'Favoriteレコードが1件減っていること' do
        expect { xhr :delete, :destroy, id: favorite.id }.
          to change { Favorite.count }.by(-1)
      end

      it 'ステータスコード200を返すこと' do
        xhr :delete, :destroy, id: favorite.id
        expect(response).to be_success
        expect(response.status).to eq(200)
      end
    end
  end
end
