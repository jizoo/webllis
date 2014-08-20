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
      before do
        post :create, id: user_post.id
        post :create, id: editor_post.id
        get :index
      end

      it '@postsに、編集者のPostオブジェクトが格納されていること' do
        expect(assigns(:posts)).to match_array(editor_post)
        expect(assigns(:posts)).not_to match_array(user_post)
      end

      it 'indexテンプレートをrenderしていること' do
        expect(response).to render_template(:index)
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

      it 'indexテンプレートをrenderしていること' do
        expect(response).to render_template(:index)
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

      it '@posts に、アクセスしたユーザのPostオブジェクトが格納されていること' do
        expect(assigns(:posts)).to match_array(user_post)
        expect(assigns(:posts)).not_to match_array(other_user_post)
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

      it '@posts に、編集者のPostオブジェクトが格納されていること' do
        expect(assigns(:posts)).to match_array(editor_post)
        expect(assigns(:posts)).not_to match_array(user_post)
      end

      it 'index を render していること' do
        expect(response).to render_template('index')
      end
    end
  end

  describe 'GET #show' do
    context '未ログインユーザがアクセスした場合' do
      context 'ユーザーの投稿を閲覧する場合' do
        before { get :show, id: user_post.id }

        it_should_behave_like '認証が必要なページ'
      end

      context '編集者の投稿を閲覧する場合' do
        it 'showテンプレートを描画' do
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

      it '@post に、リクエストした Post オブジェクトが格納されていること' do
        expect(assigns(:post)).to eq(user_post)
      end

      it '@commentに、新規Commentオブジェクトが格納されていること' do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it '@comments に、Commentオブジェクトが格納されていること' do
        expect(assigns(:comments)).to match_array(comment)
      end

      it 'showテンプレートをrenderしていること' do
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

      it '@postに、新規Postオブジェクトが格納されていること' do
        expect(assigns(:post)).to be_a_new(Post)
      end

      it 'newテンプレートをrenderしていること' do
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

      context 'パラメータが正しい場合' do
        it 'Postレコードが1件増えること' do
          expect { post :create, post: params_hash }.
            to change { Post.count }.by(1)
        end

        it '@postのshowアクションにリダイレクトすること' do
          post :create, post: params_hash
          expect(response).to redirect_to(post_path(assigns[:post]))
        end
      end

      context 'パラメータが不正な場合' do
        it 'Postレコードの件数に変化がないこと' do
          expect { post :create, post: invalid_params_hash }.
            not_to change { Post.count }
        end

        it 'newテンプレートをrenderしていること' do
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

      it '@postに、リクエストしたPostオブジェクトが格納されていること' do
        expect(assigns(:post)).to eq(user_post)
      end

      it 'editテンプレートをrenderしていること' do
        expect(response).to render_template :edit
      end
    end

    context 'ログインユーザかつ投稿していないユーザがアクセスした場合' do
      before do
        login(user)
        get :edit, id: other_user_post.id
      end

      it 'not_foundテンプレートをrenderしていること' do
        expect(response).to render_template :not_found
      end
    end
  end

  describe 'PATCH #update' do
    context '未ログインユーザがアクセスしたとき' do
      before do
        patch :update, id: user_post.id, post: params_hash
      end

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザかつ投稿したユーザがアクセスしたとき' do
      before { login(user) }

      context 'かつパラメータが正しいとき' do
        before do
          patch :update, id: user_post.id, post: attributes_for(:post, url: 'http://jizoo.net', title: 'jizoo', description: 'ブログサービスです。')
        end

        it 'Postレコードが正しく変更されていること' do
          user_post.reload
          expect(user_post.url).to eq('http://jizoo.net')
          expect(user_post.title).to eq('jizoo')
          expect(user_post.description).to eq('ブログサービスです。')
        end

        it '@postのshowアクションにリダイレクトすること' do
          expect(response).to redirect_to(post_path(assigns[:post]))
        end
      end

      context 'かつパラメータが不正なとき' do
        it 'Postレコードが変更されていないこと' do
          expect { patch :update, id: user_post.id, post: attributes_for(:post, url: '', title: 'jizoo', description: 'ブログサービスです。') }.not_to change { user_post.reload }
        end

        it 'editテンプレートをrenderしていること' do
          patch :update, id: user_post.id, post: attributes_for(:post, url: '', title: 'jizoo', description: 'ブログサービスです。')
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context '未ログインユーザがアクセスしたとき' do
      before { delete :destroy, id: user_post.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザかつ投稿したユーザがアクセスした場合' do
      before do
        post :create, id: user_post.id
        login(user)
      end

      it 'Postレコードが1件減っていること' do
        expect { delete :destroy, id: user_post.id }.
          to change { Post.count }.by(-1)
      end

      it 'トップページにリダイレクトすること' do
        delete :destroy, id: user_post.id
        expect(response).to redirect_to(root_path)
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

      it 'not_foundテンプレートをrenderしていること' do
        delete :destroy, id: user_post.id
        expect(response).to render_template :not_found
      end
    end
  end
end
