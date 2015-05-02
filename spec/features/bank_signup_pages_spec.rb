require 'spec_helper'

RSpec.describe "bank signup pages", :type => :features do

  subject { page }

  context "signup page" do
    
    let(:submit) { "Зарегистрировать" }
    let(:bank) { build :bank }
    let(:user) { build :user }

    before { visit banks_signup_path }
    
    it { should have_content("Регистрация") }
    it { should have_title(full_title("Регистрация")) }
    
    context "with invalid information" do
      
      it "should not create a bank" do
        expect { click_button submit }.not_to change(Bank, :count)
      end
      
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
        fill_in "bank[name]",                                                             with: bank.name
        fill_in "bank[website]",                                                          with: bank.website
        fill_in "bank[bank_users_attributes][0][user_attributes][first_name]",            with: user.first_name
        fill_in "bank[bank_users_attributes][0][user_attributes][last_name]",             with: user.last_name
        fill_in "bank[bank_users_attributes][0][user_attributes][email]",                 with: user.email
        fill_in "bank[bank_users_attributes][0][user_attributes][password]",              with: user.password
        fill_in "bank[bank_users_attributes][0][user_attributes][password_confirmation]", with: user.password_confirmation
        select I18n.l(user.birth_date, format: "%-d"), from: "bank[bank_users_attributes][0][user_attributes][birth_date(3i)]"
        select I18n.l(user.birth_date, format: "%B"),  from: "bank[bank_users_attributes][0][user_attributes][birth_date(2i)]"
        select I18n.l(user.birth_date, format: "%Y"),  from: "bank[bank_users_attributes][0][user_attributes][birth_date(1i)]"
        choose "bank_bank_users_attributes_0_user_attributes_gender_male"
      end

      it "should create a bank" do
        expect { click_button submit }.to change(Bank, :count).by(1)
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      context "after saving the bank" do
        
        let(:saved_user) { User.find_by(email: user.email) }
        
        before { click_button submit }
        
        it { should have_css(alert_success_css) }
        it { should have_title(full_title(saved_user.short_name)) }
        it { should have_content(saved_user.full_name) }
      end
    end
  end
end