class UsersController < ApplicationController

  ##### requerir un login para poder hacer alguna accion con el controlador
  # filtro aplicado a las accciones: edit - update
  # Before filters

  # metodos propios de la clase definidos abajo ...
  # :logged_in_user
  # :correct_user
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location # metodo from: app/helpers/sessions_helper.rb
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other # redirecionar al login_url http://127.0.0.1:3000/login
    end
  end

  # para editar o actualizar SOLO el usuario actual y no otros usuario 
  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless @user == current_user
    # redirect_to(root_url, status: :see_other) unless current_user?(@user) # hace lo mismo que la linea ant
    # current_user es un dato guardado de la sesion: app/helpers/sessions_helper.rb

    # si no es el mismo usuario lo redirecciona a: http://127.0.0.1:3000 ::: roo_url
  end
  ##### requerir un login 

  def index
    # @users = User.all  # sin paginacion 
    @users = User.paginate(page: params[:page]) # con paginacion 
  end

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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  # lo dispara el formulario de new.html.erb
  def create
    @user = User.new(user_params)
    if @user.save
      # reset_session # session metodo
      # log_in @user # funcion en helps/users_helper.rb
      # # Handle a successful save.
      # flash[:success] = "Welcome to the Sample App!"
      # # http://127.0.0.1:3000/users/:id
      # redirect_to @user
      @user.send_activation_email # metodo asociado al modelo de user 
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # lo dispara el formulario de edit.htmole.erb
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # actualizacion exitosa 
      flash[:success] = "Profile updated"
      redirect_to @user # pag del profile http://127.0.0.1:3000/users/:id , vista show 
    else
      # actualizacion no exitosa 
      render 'edit', status: :unprocessable_entity
    end

  end

  #  .../users/1/edit
  def edit
    @user = User.find(params[:id])
    puts params[:id] # referencia a los params de la ruta .../users/:id/edit
    puts @user.name
    puts @user.email
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

   # Confirms an admin user.
   def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
