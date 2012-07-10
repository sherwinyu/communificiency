require 'spec_helper'

describe User do
  before :each do
    @user_attr = { name: 'Namey User',
                   email: 'namey.user@email.com',
                   password: 'p4ssw0rd',
                   password_confirmation: 'p4ssw0rd',
    }
  end

  it "should accept a valid User" do
    u = User.new @user_attr
    u.should be_valid
  end

  it "should accept a nameless user a name" do
    nameless_user = User.new @user_attr.merge({ name: "" })
    nameless_user.should be_valid
  end

  it "should require an email" do
    emailless_user = User.new @user_attr.merge({ email: "" })
    emailless_user.should_not be_valid
  end

  it "should accept an user with a valid email" do
    valid_emails = %w[sherwinyu@google.com sherwin.yu@google.com harry@k12.fcps.edu a.b@c.e lilgirl445@aaa.tl]
    valid_emails.each do |e|
      valid_user = User.new @user_attr.merge({ email: e })
      valid_user.should be_valid
    end
  end

  it "should reject an user with an invalid email" do
    invalid_emails = %w[4sherwinyugoogle.com arf @@ a.b.c @a.b.c]
    invalid_emails.each do |e|
      invalid_user = User.new @user_attr.merge({ email: e })
      invalid_user.should_not be_valid
    end
  end

  it "should reject an user with a duplicate email" do
    User.create! @user_attr
    duplicate_email_user = User.new @user_attr.merge({ name: "Bob" })
    duplicate_email_user.should_not be_valid
  end

  it "should reject an user with a duplicate email up to case" do
    u = User.create! @user_attr
    upcase_email_user = User.new @user_attr.merge({ name: "Bob",
                                                    email: u.email.upcase })
    upcase_email_user.should_not be_valid
  end

  describe 'password validations' do
    it 'should require a password' do
      u = User.new @user_attr.merge({ password: '',
                                      password_confirmation: '' })
      u.should_not be_valid
    end

    it 'should reject an incorrect password_confirmation' do
      u = User.new @user_attr.merge({ password_confirmation: '' })
      u.should_not be_valid
    end

    it 'should reject short passwords' do
      u = User.new @user_attr.merge({ password: 'short',
                                      password_confirmation: 'short' })
      u.should_not be_valid
    end
  end

  describe "password encryption" do
    before :each do
      @user = User.create! @user_attr
    end

    it 'should have an encrypted password' do
      @user.should respond_to(:encrypted_password)
    end

    it 'should set the encrypted password' do
      @user.encrypted_password.should_not be_blank
    end

    describe "matches_password method" do

      it 'should return true on a correct match' do
        @user.matches_password?(@user_attr[:password]).should be_true
      end

      it 'should return false on an incorrect match' do
        @user.matches_password?(@user_attr[:password] + "wrong password").should be_false
      end
    end

    describe "authentication" do
      it 'should return nil when no user exists'  do
        u = User.authenticate "nonexistentemail@darkness.com", @user_attr[:password]
        u.should be_nil
      end

      it 'should return nil for an invalid email/password combination' do
        u = User.authenticate( @user_attr[:email], @user_attr[:password] + "derp" )
        u.should be_nil
      end

      it 'should return the correct user for a valid email/password combination' do
        u = User.authenticate @user_attr[:email], @user_attr[:password]
        u.should  == @user
      end
    end


  end

  # it {should respond_to :authenticate}
  it {should respond_to :admin}
  describe "with admin attribute set to 'true'" do
    before { 
      @user = User.new @user_attr
      @user.toggle! :admin }
    it { @user.should be_admin }
  end

end
