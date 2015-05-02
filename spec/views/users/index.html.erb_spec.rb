require "spec_helper"

RSpec.describe "users/index" do
  it "displays all the users" do
    superadmin = create_login_superadmin
    superadmins = []
    superadmins << superadmin
    superadmins << create_list(:superadmin, 5)
    
    render
    
    superadmins.each do |u| 
      expect(rendered).to match /#{u.full_name(middle_name: true, last_name_first: true)}/
    end
  end
end