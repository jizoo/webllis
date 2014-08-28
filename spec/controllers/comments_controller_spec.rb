require 'rails_helper'

describe CommentsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_post) { create(:post) }
  let(:comment) { create(:comment) }
  let(:sent_comment) { create :comment, creator: user, post: user_post }
  let(:received_comment) { create(:comment, reader: user, post: user_post) }
  let(:reply) { create(:reply, creator: user) }
  let(:params_hash) { attributes_for(:comment) }
  let(:invalid_params_hash) { attributes_for(:invalid_comment) }

  describe 'GET #index' do
    let(:other_comment) { create(:comment, reader: other_user) }
    let(:other_reply) { create(:reply, creator: other_user) }

    context '未ログインユーザがアクセスした場合' do
      before { get :index }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before do
        login(user)
        get :index
      end

      it '@commentsに、readerがログインユーザのcommentと、creatorがログインユーザのreplyが格納されていること' do
        expect(assigns(:comments)).to match_array([ received_comment, reply ])
        expect(assigns(:comments)).not_to match_array([ other_comment, other_reply ])
      end

      it ':indexテンプレートを表示すること' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #trashed' do
    let(:trashed_comment) { create(:comment, reader: user, reader_trashed: true) }
    let(:trashed_reply) { create(:reply, creator: user, creator_trashed: true) }
    let(:other_trashed_comment) { create(:comment, reader: other_user, reader_trashed: true) }
    let(:other_trashed_reply) { create(:reply, creator: other_user, creator_trashed: true) }

    context '未ログインユーザがアクセスした場合' do
      before { get :trashed }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before do
        login(user)
        get :trashed
      end

      it '@commentsに、readerがログインユーザかつreader_trashedがtrueのcommentと、creatorがログインユーザかつcrator_trashedがtrueのreplyが格納されていること' do
        expect(assigns(:comments)).to match_array([ trashed_comment, trashed_reply ])
        expect(assigns(:comments)).not_to match_array([ other_trashed_comment, other_trashed_reply ])
      end

      it 'indexテンプレートを表示すること' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'POST #confirm' do
    context '未ログインユーザがアクセスした場合' do
      before { post :confirm, comment: { content: 'comment' } , post_id: user_post.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before { login(user) }

      context 'パラメータが正しい場合' do
        it '@post の show アクションにリダイレクトすること' do
          # TODO
          # post :confirm, comment: params_hash , post_id: user_post.id
          # expect(response).to render_template(confirm_post_comments_path(user_post.id))
        end
      end

      context 'パラメータが不正な場合' do
        it 'posts/showテンプレートを表示すること' do
          post :create, comment: invalid_params_hash, post_id: user_post.id
          expect(response).to render_template 'posts/show'
        end
      end
    end
  end

  describe 'POST #create' do
    context '未ログインユーザがアクセスした場合' do
      before { post :create, comment: params_hash , post_id: user_post.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before { login(user) }

      context 'パラメータが正しい場合' do
        it 'Commentレコードが1件増えること' do
          # TODO
          # expect { post :create, comment: params_hash, post_id: user_post.id }.
          #   to change { Comment.count }.by(1)
        end

        it '@post の show アクションにリダイレクトすること' do
          # TODO
          # post :create, comment: { content: 'comment' } , post_id: user_post.id
          # expect(response).to redirect_to(comment_path(user_post))
        end
      end

      context 'パラメータが不正な場合' do
        it 'Comment レコードの件数に変化がないこと' do
          expect { post :create, comment: invalid_params_hash, post_id: user_post }.
            not_to change { Comment.count }
        end

        it 'posts/show テンプレートを表示すること' do
          post :create, comment: invalid_params_hash, post_id: user_post.id
          expect(response).to render_template 'posts/show'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:sent_comment) { create :comment, creator: user, post: user_post }

    context '未ログインユーザがアクセスした場合' do
      before { delete :destroy, post_id: user_post.id, id: comment.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスした場合' do
      before { login(user) }

      it 'Commentレコードが1件減っていること' do
        expect { delete :destroy, post_id: user_post.id, id: sent_comment.id}.
          to change { Comment.count }.by(-1)
      end

      it '@post の show アクションにリダイレクトすること' do
        delete :destroy, post_id: user_post.id, id: sent_comment.id
        expect(response).to redirect_to user_post
      end
    end

    context '他のユーザがアクセスした場合' do
      before { login(other_user) }

      it 'Commentレコードが減っていないこと' do
        expect { delete :destroy, post_id: user_post.id, id: sent_comment.id }.
          not_to change { Comment.count }
      end

      it 'deleted が true を返すこと' do
        delete :destroy, post_id: user_post.id, id: sent_comment.id
        sent_comment.reload
        expect(sent_comment.deleted).to be_truthy
      end
    end
  end

  describe 'PATCH #trash' do
    let!(:received_comment) { create(:comment, reader: user, post: user_post) }
    let!(:sent_comment) { create :comment, creator: user, post: user_post }

    context '未ログインユーザがアクセスした場合' do
      before { patch :trash, id: comment.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザ' do
      before { login(user) }

      context 'かつログインユーザが送信したコメントにアクセスした場合' do
        it 'creator_deleted が true を返すこと' do
          patch :trash, id: sent_comment.id
          sent_comment.reload
          expect(sent_comment.creator_trashed).to be_truthy
        end
      end

      context 'かつログインユーザが受信したコメントにアクセスした場合' do
        it 'reader_deleted が true を返すこと' do
          patch :trash, id: received_comment.id
          received_comment.reload
          expect(received_comment.reader_trashed).to be_truthy
        end
      end
    end
  end

  describe 'PATCH #recover' do
    let!(:trashed_received_comment) { create(:comment, reader: user, post: user_post, creator_trashed: true) }
    let!(:trashed_sent_comment) { create :comment, creator: user, post: user_post, reader_trashed: true}

    context '未ログインユーザがアクセスした場合' do
      before { patch :recover, id: comment.id }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザ' do
      before { login(user) }

      context 'かつログインユーザが送信したコメントにアクセスした場合' do
        context 'かつそのコメントはゴミ箱に存在する場合' do
          it 'creator_deleted が false を返すこと' do
            patch :recover, id: trashed_sent_comment.id
            trashed_sent_comment.reload
            expect(trashed_sent_comment.creator_trashed).to be_falsey
          end
        end
      end

      context 'かつログインユーザが受信したコメントにアクセスした場合' do
        context 'かつそのコメントはゴミ箱に存在する場合' do
          it 'reader_deleted が true を返すこと' do
            patch :recover, id: trashed_received_comment.id
            trashed_received_comment.reload
            expect(trashed_received_comment.reader_trashed).to be_falsey
          end
        end
      end
    end
  end

  describe 'GET #count' do
    # TODO
  end
end
