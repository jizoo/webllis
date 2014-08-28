require 'rails_helper'

describe ApplicationController do
  before { login(create(:user)) }

  controller do
    def internal_server_error
      raise
    end

    def parameter_missing_error
      raise ActionController::ParameterMissing, 'parameter missing'
    end

    def bad_request_error
      raise ActionController::BadRequest
    end

    def not_found_error
      raise ActiveRecord::RecordNotFound
    end

    def routing_error
      raise ActionController::RoutingError, 'routing error'
    end

    def forbidden_error
      raise ApplicationController::Forbidden
    end

    def ip_address_rejected_error
      raise ApplicationController::IpAddressRejected
    end
  end

  context 'InternalServerError を raise した場合' do
    before do
      routes.draw { get 'internal_server_error' => 'anonymous#internal_server_error' }
    end

    it 'internal_server_error を表示すること' do
      get :internal_server_error
      expect(response.status).to eq(500)
      expect(response).to render_template('errors/internal_server_error')
    end
  end

  context 'ParameterMissingError を raise した場合' do
    before do
      routes.draw { get 'parameter_missing_error' => 'anonymous#parameter_missing_error' }
    end

    it 'bad_request を表示すること' do
      get :parameter_missing_error
      expect(response.status).to eq(400)
      expect(response).to render_template('errors/bad_request')
    end
  end

  context 'BadRequestError を raise した場合' do
    before do
      routes.draw { get 'bad_request_error' => 'anonymous#bad_request_error' }
    end

    it 'bad_request を表示すること' do
      get :bad_request_error
      expect(response.status).to eq(400)
      expect(response).to render_template('errors/bad_request')
    end
  end

  context 'RecordNotFound を raise した場合' do
    before do
      routes.draw { get 'not_found_error' => 'anonymous#not_found_error' }
    end

    it 'not_found を表示すること' do
      get :not_found_error
      expect(response.status).to eq(404)
      expect(response).to render_template('errors/not_found')
    end
  end

  context 'RoutingError を raise した場合' do
    before do
      routes.draw { get 'routing_error' => 'anonymous#routing_error' }
    end

    it 'not_found を表示すること' do
      get :routing_error
      expect(response.status).to eq(404)
      expect(response).to render_template('errors/not_found')
    end
  end

  context 'ForbiddenError を raise した場合' do
    before do
      routes.draw { get 'forbidden_error' => 'anonymous#forbidden_error' }
    end

    it 'fobbiden を表示すること' do
      get :forbidden_error
      expect(response.status).to eq(403)
      expect(response).to render_template('errors/forbidden')
    end
  end

  context 'IpAddressRejectedError を raise した場合' do
    before do
      routes.draw { get 'ip_address_rejected_error' => 'anonymous#ip_address_rejected_error' }
    end

    it 'fobbiden を表示すること' do
      get :ip_address_rejected_error
      expect(response.status).to eq(403)
      expect(response).to render_template('errors/forbidden')
    end
  end
end
