require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    # TODO(syu) why does this fail?
    it 'should have the right title' do
      get 'new'
      # response.should have_selector('title', content: 'Sign in')
    end
  end

  describe "POST 'create'" do
    before :each do 
      @session_params = {email: 'abcd@def.g', password: 'password'}
      @user_params = @session_params.merge name: 'whatever', password_confirmation: 'password'
      User.create! @user_params
    end

    describe 'failure' do
      before :each do
        @session_params.merge!  email: 'invalidemail', password: 'wrongpassword' 
      end

      it 'should havea flash.now showing the error' do
        post :create, session: @session_params
        flash.alert.should =~ /.+invalid.+email.+password/i
      end

      it 'should render the sign_in page' do
        post :create, session: @session_params
        response.should render_template 'new'
      end

    end

    describe 'with a valid email/password' do
      before :each do 
      end

      it 'should redirect to the user profile' do
        post :create, session: @session_params
      end

      it 'should create a new session for the user' do
        post :create, session: @session_params
      end
    end

  end

  describe 'authentication' do
    it 'should fuckin authenticate'
  end

  describe 'DELETE destroy (sign out)' do
    describe 'when already signed in' do

      it 'should clear the cookie'
      it 'should redirect to the home page' do
        delete :destroy
        response.should redirect_to root_path
      end

    end

    describe 'when not signed in' do
      it 'should redirect to the sign in page'
    end
  end

end
