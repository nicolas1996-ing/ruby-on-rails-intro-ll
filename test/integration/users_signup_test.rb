require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # test para el formulario de registro ...

  test "invalid signup information" do
    get signup_path # llamado a la ruta 
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity # respuesta invalida 
    assert_template 'users/new' # template que se renderiza
    # assert_select 'div#<CSS id for error explanation>'
    # assert_select 'div.<CSS class for field with error>'
  end

  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in? # /Users/nicolasaristizabal/Desktop/somos/ruby_bootcamp/sample_app/test/test_helper.rb
  end
end
