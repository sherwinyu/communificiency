require 'spec_helper'

describe SessionsController do
  render_views
    before :each do 
      @session_params = {email: 'abcd@def.g', password: 'password'}
      @user_params = @session_params.merge name: 'whatever', password_confirmation: 'password'
      @user = User.create! @user_params
    end

=begin
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do

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

      it 'should no longer be signed in' do
        test_sign_in(@user)
        controller.should be_current_user_signed_in
        delete :destroy
        controller.current_user_signed_in?.should == false
      end

      it 'should redirect to the home page' do
        delete :destroy
        response.should redirect_to root_path
      end

    end

    describe 'when not signed in' do
      it 'should redirect to the sign in page'
    end
  end

=end
end
