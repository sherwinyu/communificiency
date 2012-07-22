require 'spec_helper'

describe 'User pages' do
  subject { page }

  describe 'edit' do
  end

  describe "sign_up" do
    before { visit sign_up_path }
    it { should have_selector('h1', text: 'Create your Communificiency Account') }
    it { should have_selector('title', text: 'Communificiency | Sign up') }
  end
end

