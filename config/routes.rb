Rails.application.routes.draw do
  get 'users/new'

  #  http://127.0.0.1:3000/static_pages/home
  #  http://127.0.0.1:3000/static_pages/help

  # primera pag que ve el usuario
  root "static_pages#home"

  # rutas relativas a root ... 
  get  "/help",    to: "static_pages#help"  # internamente va hacia http://127.0.0.1:3000/static_pages/help
  get  "/about",   to: "static_pages#about" # pero en el navegador basta con llamar http://127.0.0.1:3000/help
  get  "/contact", to: "static_pages#contact"
  get  "/signup",  to: "users#new"

  # help_path
  # about_path
  # contact_path



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # root "application#hello"
  # Defines the root path route ("/")
  # root "articles#index"
end
