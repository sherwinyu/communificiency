require 'spec_helper'

describe User do
  before do 
    @user_attr = { name: 'Namey User',
                   email: 'namey.user@email.com',
                   password: 'p4ssw0rd',
                   password_confirmation: 'p4ssw0rd',
    }
    @user = User.new @user_attr
  end

  subject { @user }
  it  { should be_valid }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :admin }
  it { should respond_to :encrypted_password }


  describe "when name is not present" do
    before { @user.name = "" }
    it { should_not be_valid }
  end

  describe "when name is nil" do
    before { @user.name = nil }
    it { should_not be_valid }
  end

  describe "when email is blank" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when email is nil" do
    before { @user.email = nil }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 41 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      invalid_emails = %w[4sherwinyugoogle.com arf @@ a.b.c @a.b.c]
      invalid_emails.each do |e|
        @user.email = e
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      valid_emails = %w[sherwinyu@google.com sherwin.yu@google.com harry@k12.fcps.edu a.b@c.e lilgirl445@aaa.tl]
      valid_emails.each do |e|
        @user.email = e
        @user.should be_valid
      end
    end
  end

  describe "when email is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when email is not unique upto case" do
    before do 
      user_with_same_email = @user.dup
      user_with_same_email.email.upcase!
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when user is saved" do
    it "should should downcase the email" do
      upcase_email = "validEmailWithCaps@gmail.com"
      @user.email = upcase_email
      @user.save
      @user.email.should == upcase_email.downcase
    end
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  describe "when password_confirmatino doesn't match" do
    before { @user.password_confirmation = "derp" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = "a"*5 }
    it { should_not be_valid }
  end

  describe "when password is too long" do
    before { @user.password = "a"*41 }
    it { should_not be_valid }
  end

  describe "retrn valueue of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do 
      it { should == User.authenticate(found_user.email, @user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { User.authenticate(found_user.email, "invalid_password") }
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false}
    end

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
