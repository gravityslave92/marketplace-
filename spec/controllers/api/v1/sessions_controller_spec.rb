require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST#create' do
    let(:user) { FactoryBot.create(:user) }

    context 'when the credentials are correct' do
      before(:each) do
        params = { session: { email: user.email, password: '12345678' } }
        post :create, params: params
      end

      it 'returns the user record corresponding to the given credentials' do
        user.reload
        expect(json_response[:auth_token]).to eql(user.auth_token)
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        params = { session: { email: user.email, password: 'invalidpassword' } }
        post :create, params: params
      end

      it 'returns a json with an error' do
        expect(json_response[:errors]).to eql 'Invalid email or password!'
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryBot.create :user
      sign_in(@user)
      delete :destroy, params: { id: @user.auth_token }
    end

    it { expect(response).to have_http_status(:no_content) }
  end
end
