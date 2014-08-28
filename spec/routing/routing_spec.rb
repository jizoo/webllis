require 'rails_helper'

describe 'ルーティング' do
  it '編集者トップページ' do
    expect(get: '/editor').to route_to(
      controller: 'editor/posts',
      action: 'index'
    )
  end

  it '管理者ログインフォーム' do
    expect(get: '/admin/login').to route_to(
      controller: 'admin/sessions',
      action: 'new'
    )
  end

  it 'トップページ' do
    expect(get: '/').to route_to(
      controller: 'posts',
      action: 'index'
    )
  end

  it '存在しないパスならerrors/not_foundへ' do
    expect(get: '/xyz').to route_to(
      controller: 'errors',
      action: 'not_found',
      anything: 'xyz'
    )
  end
end
