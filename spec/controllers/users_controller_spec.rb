require 'spec_helper'

describe UsersController do
  render_views

  before :each do
    @user_attr = { name: 'Namey User',
                   email: 'namey.user@email.com',
                   password: 'p4ssw0rd',
                   password_confirmation: 'p4ssw0rd',
    }
  end

  describe 'POST users#create' do
    before :each do
      @user_attr.merge!  name: '',                
        email: '',     
        password: 'p4ssw0rd',              
        password_confirmation: 'invalidpasswordconfirmation' 
    end

    describe 'failure' do
      it 'should render the sign up page' do
        post :create, user: @user_attr
        should render_template 'users/sign_up'
      end

      it 'should not change the user count' do
        lambda do
          post :create, user: @user_attr
        end.should_not change(User, :count)
      end

    end

    it 'should redirect a valid new signup to the profile page' do
      get :sign_up
    end
  end

end
