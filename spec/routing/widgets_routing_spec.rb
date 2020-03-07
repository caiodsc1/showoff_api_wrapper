require "rails_helper"

RSpec.describe WidgetsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/widgets").to route_to("widgets#index")
    end

    it "routes to #create" do
      expect(:post => "/widgets").to route_to("widgets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/widgets/1").to route_to("widgets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/widgets/1").to route_to("widgets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/widgets/1").to route_to("widgets#destroy", :id => "1")
    end

    it "routes to #visible" do
      expect(:get => "/widgets/visible").to route_to("widgets#visible")
    end

    it "routes to #visible with search term" do
      expect(:get => "/widgets/visible?search_term=term").to route_to("widgets#visible", :search_term => "term")
    end
  end
end
