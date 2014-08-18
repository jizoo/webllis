require 'rails_helper'

describe 'ルーティング' do
  example '編集者トップページ' do
    expect(get: '/editor').to route_to(
      controller: 'editor/posts',
      action: 'index'
    )
  end

  example '管理者ログインフォーム' do
    expect(get: '/admin/login').to route_to(
      controller: 'admin/sessions',
      action: 'new'
    )
  end

  example 'トップページ' do
    expect(get: '/').to route_to(
      controller: 'feeds',
      action: 'index'
    )
  end

  example '存在しないパスならerrors/not_foundへ' do
    expect(get: '/xyz').to route_to(
      controller: 'errors',
      action: 'not_found',
      anything: 'xyz'
    )
  end
end
