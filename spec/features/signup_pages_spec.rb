require 'spec_helper'

RSpec.describe "signup pages", :type => :features do

  subject { page }

  context "signup page" do
    
    let(:submit) { "Зарегистрироваться" }
    let(:user) { build :user }
    
    before { visit signup_path }
    
    it { should have_content("Регистрация") }
    it { should have_title(full_title("Регистрация")) }
    
    context "with invalid information" do
      
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      context "after submission" do
        
        before { click_button submit }

        it { should have_title("Регистрация") }
        it { should have_css(li_danger_css) }
        it { should have_css(field_with_errors_css) }
      end
    end
    
    context "with valid information" do
      
      before do
        fill_in "user[first_name]",                         with: user.first_name
        fill_in "user[last_name]",                          with: user.last_name
        fill_in "user[email]",                              with: user.email
        fill_in "user[password]",                           with: user.password
        fill_in "user[password_confirmation]",              with: user.password_confirmation
        select I18n.l(user.birth_date, format: "%-d"), from: "user_birth_date_3i"
        select I18n.l(user.birth_date, format: "%B"),  from: "user_birth_date_2i"
        select I18n.l(user.birth_date, format: "%Y"),  from: "user_birth_date_1i"
        choose "user_gender_male"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      context "after saving the user" do
        
        let(:saved_user) { User.find_by(email: user.email) }
        
        before { click_button submit }
        
        it { should have_css(alert_success_css) }
        it { should have_title(full_title(saved_user.short_name)) }
        it { should have_content(saved_user.full_name) }
      end
    end
  end
  
  context "profile page" do
    
    let(:user) { create_login_user }
    
    before { visit user_path(user) }
    
    it { should have_title(full_title(user.short_name)) }
    it { should have_content(user.full_name) }
  end
end