require 'spec_helper'

describe StaticPagesController  do
=begin
  render_views

  describe "sign up" do
    it "should have the content 'sign up'" do
      visit '/sign_up'
      page.should have_content('Sign up')
    end
  end

  describe "coming_soon" do
    it "should have the content 'sign up'" do
      visit '/coming_soon'
      page.should have_content('Coming soon!')
    end
  end

  describe "About" do
    it "should have the content 'About'" do
      visit '/about'
      page.should have_content('About')
      page.should have_content('Our vision')
    end

    it "should have the right title" do
      visit '/about'
      page.should have_selector('title', text: "About")
    end
  end


  before :each do
    @user_attr = { name: 'Namey User', 
                   email: 'namey.user@email.com',
                   password: 'p4ssw0rd',
                   password_confirmation: 'p4ssw0rd',
    }
  end

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
      get :sign_up
    end
  end

=end
end
