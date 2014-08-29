require 'rails_helper'

describe PostsController do
  let(:user) { create(:user) }
  let(:other_user) { create :user }
  let(:editor) { create(:editor) }
  let(:user_post) { create(:post, user: user, title: 'User Post') }
  let(:other_user_post) { create(:post, user: other_user, title: 'Other User Post') }
  let(:editor_post) { create(:post, user: editor, title: 'Editor Post') }
  let(:params_hash) { attributes_for(:post) }
  let(:invalid_params_hash) { attributes_for(:invalid_post) }
  let(:comment) { create(:comment, post: user_post, creator: editor, reader: user) }

  describe 'GET #index' do
    context '未ログインユーザがアクセスした場合' do
      let!(:user_post) { create(:post, user: user) }
      let!(:editor_post) { create(:post, user: editor) }

      before do
        get :index
      end

      it '編集者の投稿を配列にまとめること' do
        expect(assigns(:posts)).to match_array [editor_post]
        expect(assigns(:posts)).not_to match_array [user_post]
      end

      it ':indexテンプレートを表示すること' do
        expect(response).to render_template :index
      end
    end

    context '未ログインユーザが検索した場合' do
      #TODO
    end

    context '未ログインユーザがタグにアクセス場合' do
      #TODO
    end

    context 'ログインユーザがアクセスした場合' do
      before do
        post :create, id: user_post.id
        post :create, id: other_user_post.id
        login(user)
        get :index
      end

      it '@posts' do
        # expect(assigns(:posts)).to match_array(user_post)
        # expect(assigns(:posts)).to match_array(other_user_post)
      end

      it 'indexテンプレートを表示すること' do
        expect(response).to render_template :index
      end
    end

    context 'ログインユーザが検索した場合' do
      #TODO
    end

    context 'ログインユーザがタグにアクセス場合' do
      #TODO
    end
  end

  describe 'GET #posted' do
    context '未ログインユーザがアクセスした場合' do
      before { get :posted }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before do
        post :create, id: user_post.id
        post :create, id: other_user_post.id
        login(user)
        get :index
      end

      it 'アクセスしたユーザの投稿を配列にまとめること' do
        expect(assigns(:posts)).to match_array [user_post]
        expect(assigns(:posts)).not_to match_array [other_user_post]
      end

      it 'index を render していること' do
        expect(response).to render_template('index')
      end
    end
  end

  describe 'GET #favorite' do
    context '未ログインユーザがアクセスした場合' do
      before { get :favorite }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before do
        post :create, id: user_post.id
        post :create, id: other_user_post.id
        login(user)
        get :favorite
      end

      it '@posts' do
        #TODO
      end

      it 'index を render していること' do
        expect(response).to render_template('index')
      end
    end
  end

  describe 'GET #picked' do
    context '未ログインユーザがアクセスした場合' do
      before { get :picked }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before do
        post :create, id: user_post.id
        post :create, id: editor_post.id
        login(user)
        get :picked
      end

      it '編集者の投稿を配列にまとめること' do
        expect(assigns(:posts)).to match_array [editor_post]
        expect(assigns(:posts)).not_to match_array [user_post]
      end

      it ':indexテンプレートを表示すること' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    context '未ログインユーザがアクセスした場合' do
      context 'ユーザの投稿を閲覧する場合' do
        before { get :show, id: user_post.id }

        it_should_behave_like '認証が必要なページ'
      end

      context '編集者の投稿を閲覧する場合' do
        it 'showテンプレートを表示すること' do
          get :show, id: editor_post.id
          expect(response).to render_template(:show)
        end
      end
    end

    context 'ログインユーザがアクセスした場合' do
      before do
        login(user)
        get :show, id: user_post.id
      end

      it '@postに要求された投稿を割り当てること' do
        expect(assigns(:post)).to eq user_post
      end

      it '@commentに新しいコメントを割り当てること' do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it '@commentsに指定された投稿に対するコメントを配列でまとめること' do
        expect(assigns(:comments)).to match_array [comment]
      end

      it ':showテンプレートを表示すること' do
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #new' do
    context '未ログインユーザがアクセスした場合' do
      before { get :new }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before do
        login(user)
        get :new
      end

      it 'ステータスコードとして200が返ること' do
        expect(response.status).to eq(200)
      end

      it '@postに新しい投稿を割り当てること' do
        expect(assigns(:post)).to be_a_new(Post)
      end

      it ':newテンプレートを表示すること' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create' do
    context '未ログインユーザがアクセスした場合' do
      before { get :create, post: params_hash }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before { login(user) }

      context '有効な属性の場合' do
        it 'データベースに新しい投稿を保存すること' do
          expect { post :create, post: params_hash }.
            to change { Post.count }.by(1)
        end

        it 'post#showにリダイレクトすること' do
          post :create, post: params_hash
          expect(response).to redirect_to post_path(assigns[:post])
        end

        it 'avatarをアップロードする'
      end

      context '無効な属性の場合' do
        it 'データベースに新しい投稿を保存しないこと' do
          expect { post :create, post: invalid_params_hash }.
            not_to change { Post.count }
        end

        it ':newテンプレートを再表示すること' do
          post :create, post: invalid_params_hash
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET #edit' do
    context '未ログインユーザがアクセスした場合' do
      before { get :edit, id: user_post.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザかつ投稿したユーザがアクセスした場合' do
      before do
        login(user)
        get :edit, id: user_post.id
      end

      it 'postに要求された投稿を割り当てること' do
        expect(assigns(:post)).to eq user_post
      end

      it ':editテンプレートを表示すること' do
        expect(response).to render_template :edit
      end
    end

    context 'ログインユーザかつ投稿していないユーザがアクセスした場合' do
      before do
        login(user)
        get :edit, id: other_user_post.id
      end

      it 'not_foundテンプレートを表示すること' do
        expect(response).to render_template :not_found
      end
    end
  end

  describe 'PATCH #update' do
    context '未ログインユーザがアクセスした場合' do
      before do
        patch :update, id: user_post.id, post: params_hash
      end

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザかつ投稿したユーザがアクセスした場合' do
      before { login(user) }

      context 'かつ有効な属性の場合' do
        before do
          patch :update, id: user_post.id, post: attributes_for(:post, url: 'http://jizoo.net', title: 'jizoo', description: 'ブログサービスです。')
        end

        it '要求された@postを取得すること' do
          patch :update, id: user_post.id, post: attributes_for(:post)
          expect(assigns(:post)).to eq(user_post)
        end

        it '@postの属性を変更すること' do
          user_post.reload
          expect(user_post.url).to eq('http://jizoo.net')
          expect(user_post.title).to eq('jizoo')
          expect(user_post.description).to eq('ブログサービスです。')
        end

        it '更新した投稿ページヘリダイレクトすること' do
          expect(response).to redirect_to post_path(assigns[:post])
        end
      end

      context 'かつ無効な属性な場合' do
        it '投稿の属性を変更しないこと' do
          expect {
            patch :update, id: user_post.id,
              post: attributes_for(
                :post,
                  url: nil, title: 'jizoo', description: 'ブログサービスです。'
              )
          }.not_to change { user_post.reload }
        end

        it ':editテンプレートを再表示すること' do
          patch :update, id: user_post.id, post: attributes_for(:post, url: nil, title: 'jizoo', description: 'ブログサービスです。')
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context '未ログインユーザがアクセスした場合' do
      before { delete :destroy, id: user_post.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザかつ投稿したユーザがアクセスした場合' do
      before do
        post :create, id: user_post.id
        login(user)
      end

      it '投稿を削除すること' do
        expect { delete :destroy, id: user_post.id }.
          to change { Post.count }.by(-1)
      end

      it 'トップページにリダイレクトすること' do
        delete :destroy, id: user_post.id
        expect(response).to redirect_to root_url
      end
    end

    context 'ログインユーザかつイベントを投稿していないユーザがアクセスした場合' do
      before do
        post :create, id: user_post.id
        login(other_user)
      end

      it 'Postレコードが減っていないこと' do
        expect { delete :destroy, id: user_post.id }.
          not_to change { Post.count }
      end

      it 'not_foundテンプレートを表示すること' do
        delete :destroy, id: user_post.id
        expect(response).to render_template :not_found
      end
    end
  end
end
