require 'spec_helper'

describe User do
  before :each do
    @user_attr = { name: 'Namey User', email: 'namey.user@email.com' }
  end

  it "should accept a valid User" do
    valid_user = User.new @user_attr
    valid_user.should be_valid
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
  
end
