require 'spec_helper'

include Devise::TestHelpers

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ContributionsController do

  # This should return the minimal set of attributes required to create a valid
  # Contribution. As you add validations to Contribution, be sure to
  # update the return value of this method accordingly.
  let(:project) { FactoryGirl.create :project_with_rewards }
  let(:contribution) { FactoryGirl.create :contribution }
  let(:reward) { project.rewards.first }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    project.save
    sign_in user
  end

  def valid_attributes
    { 
      reward_id: reward.id,
      project_id: project.id,
      amount: reward.minimum_contribution
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ContributionsController. Be sure to keep this updated too.


=begin
  describe " control access" do 
    it "should deny access to 'create'" 
      # post :create, project_id: project.id, contribution: valid_attributes
      # response.should redirect_to sign_in_path
    it "should allow acccess to 'new'" do 
      get :new, project_id: project.id
      response.should redirect_to sign_in_path
      # response.should be_success
    end
  end
=end


=begin
  describe "disallow member-only actions when not logged in (guest/unprivileged)" do
    include Devise::TestHelpers
    after { response.should redirect_to new_user_session_path }

    it { get :new }
    # it { get :edit, :id => user }
    it { post :create, :contribution => FactoryGirl.attributes_for(:contribution) }
    # it { put :update, :id => person, :person => {'these' => 'params'} }
    # it { delete :destroy, :id => person }
    # it { post :create_thing, :id => person, :what => 'stuff' }
  end
=end



  describe "GET new" do
    let(:params) { {project_id: project.id} }
    let(:prepare_session) do
      sign_in user 
    end
    before do 
      request.env['HTTPS'] = 'on'
      request.env["devise.mapping"] = Devise.mappings[:user]
      prepare_session
      get :new, params
    end
    it { should respond_with :success }

    describe "when not signed in" do
      before { sign_out user }
      # should throw an error because Devise requires us to be signed in
      it {should raise_error}
    end

    describe "when signed in with unconfirmed user" do
      let(:prepare_session) { sign_in unconfirmed_user }
      it { should respond_with :success }
    end

    specify { session[:contrib_params].with_indifferent_access.should == {amount: 0, project_id: project.id}.with_indifferent_access }

    describe "when amount is specified" do
      let(:params) { {project_id: project.id, contribution: {amount: 25}} }
      specify { session[:contrib_params].should == {amount: "25", project_id: project.id}.with_indifferent_access }
    end

    describe "when amount and reward are specified" do
      let(:params) { {project_id: project.id, reward_id: reward.id, contribution: {amount: 25}} }
      specify { session[:contrib_params].should == {amount: "25", reward_id: reward.id, project_id: project.id }.with_indifferent_access }
    end
  end


  describe "POST create" do
    let(:prepare_session) { sign_in user }
    before do
      request.env['HTTPS'] = 'on'
      session[:contrib_params] = {reward_id: reward.id, amount: reward.minimum_contribution }
      prepare_session
    end


    describe "when signed in with unconfirmed user" do
      let(:prepare_session) { sign_in unconfirmed_user }
      it "should create a contribution and reward" do
        Payment.any_instance.stub(:stripe_pay!).and_return(nil)
        expect { post :create, params}.to  change(Contribution, :count).by(1)
        expect { post :create, params}.to redirect_to project_path(project, status: 'success')
      end
    end

    let(:params) {{project_id: project.id, contribution: {payment_transaction_provider: "STRIPE"} }}
    # before { post :create, params }

    # TODO(SYU) fix this test to actually use @contribution.payment.amazon_cbui_url
=begin
    it "should redirect to the payment url" do
      post :create, params
      payment = Payment.new amount: reward.minimum_contribution
      payment.id = Payment.last.id
      url = payment.amazon_cbui_url Contribution.last
      response.should redirect_to url
    end
=end

    describe "with valid params" do
      it "should create a contribution and reward" do
        Payment.any_instance.stub(:stripe_pay!).and_return(nil)
        expect { post :create, params}.to  change(Contribution, :count).by(1)
        expect { post :create, params}.to redirect_to project_path(project, status: 'success')
      end
    end

    describe "when POST params differ from session params" do
      let(:params) {{ project_id: project.id, contribution: {payment_transaction_provider: "AMAZON", reward_id: project.rewards.second.id, amount: project.rewards.second.minimum_contribution} }}
      before { post :create, params }

      it "creates the contribution with the POST params" do
        assigns(:contribution).reward_id.should == project.rewards.second.id
        assigns(:contribution).amount.should == project.rewards.second.minimum_contribution
      end
    end

    describe "when params are invalid" do
      before { post :create, params }
      let(:params) {{ project_id: project.id, contribution: {payment_transaction_provider: "AMAZON", amount: -1 }}}
      it { should render_template("new") }

      describe "when project_id is inalid" do
        let(:params) {{ project_id: -44, contribution: {amount: -1 }}}
        before { post :create, params }
        it { should render_template("new") }
      end
    end
  end

  describe "GET index" do
    let(:params) { {project_id: project.id} }
    let(:prepare_session) do
      sign_in user 
    end
    before do 
      @request.env["devise.mapping"] = Devise.mappings[:user]
      prepare_session
      get :index, params
    end

    describe "when not signed in" do
      let(:prepare_session) { sign_out user }
      # should throw an error because Devise requires us to be signed in
      it {should raise_error}
    end

    describe "when signed in with non admin user" do
      it { should redirect_to home_path }
      it { should set_the_flash[:alert].to("Sorry, you don't have access to that.") }
    end

    describe "when signed in with admin" do
      let(:prepare_session) { sign_in admin }
      it { should render_template 'contributions/index' }
    end


  end

  describe "GET show" do
    let(:params) { {project_id: project.id, id: contribution.id} }
    let(:prepare_session) do
      sign_in user 
    end

    before do 
      @request.env["devise.mapping"] = Devise.mappings[:user]
      prepare_session
      get :show, params
    end

    describe "when not signed in" do
      let(:prepare_session) { sign_out user }
      # should throw an error because Devise requires us to be signed in
      it {should raise_error}
    end

    describe "when signed in with non admin user" do
      it { should redirect_to home_path }
      it { should set_the_flash[:alert].to("Sorry, you don't have access to that.") }
    end

    describe "when signed in with admin" do
      let(:prepare_session) { sign_in admin }
      it { should render_template 'contributions/show' }
    end


  end

  describe "redirects to HTTPS" do
    describe "when GET new" do
      let(:params) { {project_id: project.id} }
      before { get :new, params }
      it { should respond_with :redirect }
    end

    describe "when POST create" do
      let(:params) {{project_id: project.id, contribution: {payment_transaction_provider: "AMAZON"} }}
      before { post :create, params }
      it { should respond_with :redirect }
    end

  end

=begin

  describe "GET index" do
    it "assigns all contributions as @contributions" do
      contribution = Contribution.create! valid_attributes
      get :index, {}, valid_session
      assigns(:contributions).should eq([contribution])
    end
  end

  describe "GET show" do
    it "assigns the requested contribution as @contribution" do
      contribution = Contribution.create! valid_attributes
      get :show, {:id => contribution.to_param}, valid_session
      assigns(:contribution).should eq(contribution)
    end
  end

  describe "GET new" do
    it 'should require you to sign in'

    describe "GETS new with a valid reward and project combo" do

      it 'should create a new contribution'

      it "assigns a new contribution as @contribution" do
        get :new, {}, valid_session
        assigns(:contribution).should be_a_new(Contribution)
      end
    end

    describe 'GETS new with an invalid reward and project combo' do
      it 'should redirect to project page with an error'
    end


  end

  describe "GET edit" do
    it "assigns the requested contribution as @contribution" do
      contribution = Contribution.create! valid_attributes
      get :edit, {:id => contribution.to_param}, valid_session
      assigns(:contribution).should eq(contribution)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Contribution" do
        expect {
          post :create, {:contribution => valid_attributes}, valid_session
        }.to change(Contribution, :count).by(1)
      end

      it "assigns a newly created contribution as @contribution" do
        post :create, {:contribution => valid_attributes}, valid_session
        assigns(:contribution).should be_a(Contribution)
        assigns(:contribution).should be_persisted
      end

      it "redirects to the created contribution" do
        post :create, {:contribution => valid_attributes}, valid_session
        response.should redirect_to(Contribution.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contribution as @contribution" do
        # Trigger the behavior that occurs when invalid params are submitted
        Contribution.any_instance.stub(:save).and_return(false)
        post :create, {:contribution => {}}, valid_session
        assigns(:contribution).should be_a_new(Contribution)
      end


it "re-renders the 'new' template" do
  # Trigger the behavior that occurs when invalid params are submitted
  Contribution.any_instance.stub(:save).and_return(false)
  post :create, {:contribution => {}}, valid_session
  response.should render_template("new")
end
end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested contribution" do
        contribution = Contribution.create! valid_attributes
        # Assuming there are no other contributions in the database, this
        # specifies that the Contribution created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Contribution.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => contribution.to_param, :contribution => {'these' => 'params'}}, valid_session
      end

it "assigns the requested contribution as @contribution" do
  contribution = Contribution.create! valid_attributes
  put :update, {:id => contribution.to_param, :contribution => valid_attributes}, valid_session
  assigns(:contribution).should eq(contribution)
end

it "redirects to the contribution" do
  contribution = Contribution.create! valid_attributes
  put :update, {:id => contribution.to_param, :contribution => valid_attributes}, valid_session
  response.should redirect_to(contribution)
end
end

describe "with invalid params" do
  it "assigns the contribution as @contribution" do
    contribution = Contribution.create! valid_attributes
    # Trigger the behavior that occurs when invalid params are submitted
    Contribution.any_instance.stub(:save).and_return(false)
    put :update, {:id => contribution.to_param, :contribution => {}}, valid_session
    assigns(:contribution).should eq(contribution)
  end

  it "re-renders the 'edit' template" do
    contribution = Contribution.create! valid_attributes
    # Trigger the behavior that occurs when invalid params are submitted
    Contribution.any_instance.stub(:save).and_return(false)
    put :update, {:id => contribution.to_param, :contribution => {}}, valid_session
    response.should render_template("edit")
  end
end
  end

  describe "DELETE destroy" do
    it "destroys the requested contribution" do
      contribution = Contribution.create! valid_attributes
      expect {
        delete :destroy, {:id => contribution.to_param}, valid_session
      }.to change(Contribution, :count).by(-1)
    end

    it "redirects to the contributions list" do
      contribution = Contribution.create! valid_attributes
      delete :destroy, {:id => contribution.to_param}, valid_session
      response.should redirect_to(contributions_url)
    end
  end


end
=end
end

