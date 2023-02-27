require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user) # simular que un usuario esta logeado 
    get edit_user_path(@user) # llama a la ruta de edicion ..users/:id/edit 
    assert_template 'users/edit' # verifica que la vista sea renderizada 

    # intenta hace path con datos invalidos 
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    
    # verifica que se renderice nuevamente la vista de users/edit
    assert_template 'users/edit'

    # verificando el contenido del div de errores que contienen la clase alert 
    assert_select "div.alert", text: "The form contains 4 errors."
  end

  test "successful edit" do
    log_in_as(@user) # simular que un usuario esta logeado 
    get edit_user_path(@user) # ruta de edicion ...user/:id/edit 
    assert_template 'users/edit' # verifica que la vista sea renderizada 

    # variables para el test ... 
    name  = "Foo Bar"
    email = "foo@bar.com"
    
    # intenta hacer un path del user 
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }

    assert_not flash.empty? # success 
    assert_redirected_to @user # redireccionar a la pagina del perfil de usuario 
    @user.reload # carga nuevamente los datos del user directamente de la bd 
    assert_equal name,  @user.name # verifica que la info este actualizada 
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user) # muestr pag de edicion 

    # intenta actualizar el usuario actual 
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty? # no avisos de errores
    assert_redirected_to @user # redireeciona a la pagina ...user/:id
    @user.reload # recarga la pag 
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end