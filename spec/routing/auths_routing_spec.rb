require "rails_helper"

RSpec.describe AuthsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(:post => "/auths/create").to route_to("auths#create")
    end

    it "routes to #refresh" do
      expect(:post => "/auths/refresh").to route_to("auths#refresh")
    end

    it "routes to #revoke" do
      expect(:post => "/auths/revoke").to route_to("auths#revoke")
    end
  end
end
