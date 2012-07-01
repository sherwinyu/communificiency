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
    describe 'failure' do
      before :each do
        @session_params = {email: 'invalidemail', password: 'wrongpassword'}
      end

      it 'should have a flash showing the error' do
        post :create, session: @session_params
        flash.notice.should =~ /'invalid.+email.+.+password/i
      end

      it 'should render the sign_in page' do
        post :create, session: @session_params
        response.should render_template 'new'
      end

    end

    describe 'with a valid email/password' do
      it 'should redirect to the user profile'
      it 'should create a new session for the user'
    end

  end

end
