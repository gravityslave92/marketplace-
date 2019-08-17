require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET#show' do
    before(:each) do
      @user = FactoryBot.create(:user)
      get :show, params: { id: @user.id, format: :json }
    end

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:email]).to eql(@user.email)
    end

    it { expect(response).to be_success }
  end

  describe 'POST#create' do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for(:user)
        post :create, params: { user: @user_attributes }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        expect(json_response[:email]).to eql(@user_attributes[:email])
      end

      it { expect(response).to have_http_status(:created) }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_users_attributes = {
          password: '12345678',
          password_confirmation: '12345678',
        }
        post :create, params: { user: @invalid_users_attributes }, format: :json
      end

      it 'renders an error json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:email]).to include("can't be blank")
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) do
        @user = FactoryBot.create :user
        api_authorization_header @user.auth_token
        params = { id: @user.id, user: { email: 'newmail@example.com' } }
        patch :update, params: params, format: :json
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:email]).to eql 'newmail@example.com'
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when is not created' do
      before(:each) do
        @user = FactoryBot.create :user
        api_authorization_header @user.auth_token
        params =  { id: @user.id, user: { email: 'bademail.com'} }
        patch :update, params: params, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:email]).to include('is invalid')
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryBot.create(:user)
      api_authorization_header @user.auth_token
      delete :destroy, params: { id: @user.id }, format: :json
    end

    it { expect(response).to have_http_status(:no_content) }
  end
end
