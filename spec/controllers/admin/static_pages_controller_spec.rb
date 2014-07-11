require 'rails_helper'

describe Admin::StaticPagesController do
  let(:administrator) { create(:administrator) }

  before do
    login(administrator)
  end

  describe '#home' do
    example '通常はstatic_pages/home/dashboardを表示' do
      get :home
      expect(response).to render_template('admin/static_pages/dashboard')
    end
  end
end
