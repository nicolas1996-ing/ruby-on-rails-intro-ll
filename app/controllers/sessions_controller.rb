class SessionsController < ApplicationController
  def new
  end

  # se dispara cuando el formulario de inicio de sesion es submmit 
  # inicio de sesion 
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      reset_session # seguridad 
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # recordar o no la sesion 
      remember user # function from session_helpe.rb
      log_in user # seguridad 
      redirect_to user # llama al controlador users y renderiza el metodo show .. views>>users>>show.html.erb
      puts "valid user"
    else
      # Create an error message.
      puts "invalid user"
      # flash.now necesario para que aparezca/desaparezca
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new', status: :unprocessable_entity
    end
  end

  # fin de la sesion 
  def destroy
    log_out if logged_in?
    log_out # controllers/sessions_helpers
    redirect_to root_url, status: :see_other # pag de inicio
  end
end
