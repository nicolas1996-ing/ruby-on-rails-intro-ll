Rails.application.routes.draw do

  #  http://127.0.0.1:3000/static_pages/home
  #  http://127.0.0.1:3000/static_pages/help

  # primera pag que ve el usuario
  root "static_pages#home"

  # rutas relativas a root ... 
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/contact'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # root "application#hello"
  # Defines the root path route ("/")
  # root "articles#index"
end
