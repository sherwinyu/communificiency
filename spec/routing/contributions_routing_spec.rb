require "spec_helper"

describe ContributionsController do
  describe "routing" do

    # it "routes to #index" do
      # get("/contributions").should route_to("contributions#index")
    # end

    it "routes to #new" do
      get("projects/1/contributions/new").should route_to("contributions#new", project_id: "1")
    end

    # it "routes to #show" do
      # # get("/contributions/1").should route_to("contributions#show", :id => "1")
    # end

    # it "routes to #edit" do
      # get("/contributions/1/edit").should route_to("contributions#edit", :id => "1")
    # end

    it "routes to #create" do
      post("projects/1/contributions").should route_to("contributions#create", project_id: "1")
    end

    # it "routes to #update" do
      # put("/contributions/1").should route_to("contributions#update", :id => "1")
    # end

    # it "routes to #destroy" do
      # delete("/contributions/1").should route_to("contributions#destroy", :id => "1")
    # end

  end
end
