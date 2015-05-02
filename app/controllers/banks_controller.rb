class BanksController < ApplicationController
  
  layout "dashboard", except: :signup
  
  def create
    @bank = Bank.new(bank_params)
    if @bank.save
      @user = @bank.users(true).first
      log_in @user
      flash[:success] = t ".flash.success.message"
      redirect_to @user
    else
      render 'signup'
    end
  end

  def signup
    @bank       = Bank.new
    @bank_users = @bank.bank_users.build
    @user       = @bank_users.build_user
  end

  private

  def bank_params
    params.require(:bank).permit(:name, :website, bank_users_attributes: [{ user_attributes: [:first_name, 
                                  :last_name, :birth_date, :gender, :email, :password, :password_confirmation] }])
  end
end
