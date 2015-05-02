require 'spec_helper'

RSpec.describe "authentication pages", type: :features do
  
  subject { page }

  context "login page" do
    
    before { visit login_path }

    it { should have_content('Вход') }
    it { should have_title(full_title('Вход')) }
  end
  
  context "login" do
    
    let(:submit) { "Войти" }
    
    before { visit login_path }

    context "with invalid information" do
      
      before { click_button submit }

      it { should have_title(full_title('Вход')) }
      it { should have_selector(alert_danger_css) }
      
      describe "after visiting another page" do
        
        before { click_link "Частным клиентам" }
        
        it { should_not have_selector(alert_danger_css) }
      end
    end
    
    context "with valid information" do
      
      let(:user) { FactoryGirl.create(:user) }
      
      before do
        fill_in "session_email",    with: user.email.upcase
        fill_in "session_password", with: user.password
        click_button submit
      end

      it { should have_title(user.short_name) }
      it { should have_link('Панель управления', href: user_path(user, locale: I18n.locale)) }
      it { should have_link('Выйти', href: logout_path(locale: I18n.locale)) }
    end
  end
end
