require 'spec_helper'
include Devise::TestHelpers

describe UsersController do
  render_views

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before :each do
    @user_attr = { name: 'Namey User', 
                   email: 'namey.user@email.com',
                   password: 'p4ssw0rd',
                   password_confirmation: 'p4ssw0rd',
    }
  end
  describe 'GET users/1' do
    let(:params) { {id: 1} }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]

    end

    it 'should raise error when not logged in' do
      # before {}
      expect { get :show, id: 1 }.to raise_error
    end

    describe "when logged in as non admin" do
      before do
        sign_in user
        get :show, id: 1 
      end
      it { should_not assign_to(:user) }

      # it { should_not raise_error }
    end
  end


=begin
  describe 'POST users#create' do

    describe 'failure' do

      before :each do
        @user_attr.merge!  name: '',                
          email: '',     
          password: 'p4ssw0rd',              
          password_confirmation: 'invalidpasswordconfirmation' 
      end

      it 'should render the sign up page' do
        post :create, user: @user_attr
        response.should render_template 'users/sign_up'
      end

      it 'should not change the user count' do
        lambda do
          post :create, user: @user_attr
        end.should_not change(User, :count)
      end

    end

    describe 'success' do
      before :each do 
        @user = User.new @user_attr
        puts @user_attr
      end

      it 'should redirect to the profile page' do
        post :create, user: @user_attr
        #response.should render_template 'users/show', 
        response.should redirect_to user_path(assigns(:user))
      end

      it 'should increase users by 1' do
        lambda do
          post :create, user: @user_attr
        end.should change(User, :count).by(1)
      end

      it 'should display a flash notice' do
        post :create, user: @user_attr
        flash.notice.should =~ /your profile was successfully created/i
      end
    end

    it 'should redirect a valid new signup to the profile page' do
      # TODO(syu) get :sign_upd
    end
  end
=end

end
