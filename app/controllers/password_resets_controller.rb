class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase) # buqueda en bd
    if @user
      puts "==========="
      puts @user.name
      puts params[:password_reset] # hash/objeto ... ejemplo: {"email"=>"example-99@railstutorial.org"}

      #  metodos definidos en el modelo User
      @user.create_reset_digest
      @user.send_password_reset_email

      puts "============reset password======="
      puts @user.reset_digest
      puts @user.reset_sent_at

      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end
end
