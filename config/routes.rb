Rails.application.routes.draw do
  get 'static/index'

  root 'static#index'
  # Rutas para la API REST
  namespace :api do
    resources :features, only: [:index, :show, :create] do
      resources :comments, only: [:create, :index, :show]
    end
  end

  # Ruta para verificar el estado de salud de la aplicación
  get "up" => "rails/health#show", as: :rails_health_check

  # Ruta raíz de la aplicación (opcional)
  # root "nombre_del_controlador#accion"
end
