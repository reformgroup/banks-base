require 'spec_helper'

RSpec.describe "main pages", :type => :features do
  
  subject { page }
  
  context "root page" do
    
    before { visit root_path }
    
    it { should have_link('Частным клиентам') }
    it { should have_link('Для бизнеса', href: company_path(locale: I18n.locale)) }
    it { should have_link('Банкам', href: banks_path(locale: I18n.locale)) }
    it { should have_link('Регистрация', href: signup_path(locale: I18n.locale)) }
    it { should have_title(full_title('Частным клиентам')) }
  end
  
  context "company page" do
    
    before { visit company_path }
    
    it { should have_link('Частным клиентам', href: root_path(locale: I18n.locale)) }
    it { should have_link('Для бизнеса') }
    it { should have_link('Банкам', href: banks_path(locale: I18n.locale)) }
    it { should have_link('Регистрация', href: signup_path(locale: I18n.locale)) }
    it { should have_title(full_title('Для бизнеса')) }
  end

  context "banks page" do
    
    before { visit banks_path }
    
    it { should have_link('Частным клиентам', href: root_path(locale: I18n.locale)) }
    it { should have_link('Для бизнеса', href: company_path(locale: I18n.locale)) }
    it { should have_link('Банкам') }
    it { should have_link('Регистрация', href: signup_path(locale: I18n.locale)) }
    it { should have_title(full_title('Банкам')) }
  end
end