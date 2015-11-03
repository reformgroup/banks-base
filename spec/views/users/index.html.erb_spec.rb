require "spec_helper"

RSpec.describe "users/index" do
  it "displays all the users" do
    admin = create_login_admin
    admins = []
    admins << admin
    admins << create_list(:superadmin, 5)
    
    render
    
    admins.each do |u| 
      expect(rendered).to match /#{u.full_name(middle_name: true, last_name_first: true)}/
    end
  end
end