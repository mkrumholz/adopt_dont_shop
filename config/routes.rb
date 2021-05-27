Rails.application.routes.draw do
  root 'application#welcome'

  resources :applications, :pet_applications, :pets, :shelters, :veterinarians, :veterinary_offices
  namespace :admin do
    resources :shelters, only: [:index, :show]
    resources :applications, only: [:index, :show]
  end

  get '/shelters/:shelter_id/pets', to: 'shelters#pets'
  get '/shelters/:shelter_id/pets/new', to: 'pets#new'
  post '/shelters/:shelter_id/pets', to: 'pets#create'

  get '/veterinary_offices/:veterinary_office_id/veterinarians', to: 'veterinary_offices#veterinarians'
  get '/veterinary_offices/:veterinary_office_id/veterinarians/new', to: 'veterinarians#new'
  post '/veterinary_offices/:veterinary_office_id/veterinarians', to: 'veterinarians#create'
end
