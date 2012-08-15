require "spec_helper"

describe ProjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/projects").should route_to("projects#show", :id => "1")
    end

    it "routes to #new" do
      get("/projects/new").should route_to("projects#new")
    end

    it "routes to #show" do
      get("/projects/1").should route_to("projects#show", :id => "1")
    end
  end
end
