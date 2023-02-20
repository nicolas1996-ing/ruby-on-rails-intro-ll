class UsersController < ApplicationController

  def show
    # @user es una variable disponible para usar en show.html.erb
    @user = User.find(params[:id])
    # para el flujo de la aplicacion en este punto
    # debugger
  end

  def new
    # @user es una variable lista para usar en new.html.erb
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save

      reset_session # test ???
      log_in @user # funcion en helps/users_helper.rb

      # Handle a successful save.
      flash[:success] = "Welcome to the Sample App!"
      # http://127.0.0.1:3000/users/:id
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
