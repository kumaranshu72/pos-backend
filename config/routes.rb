Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/create' => 'item#create'
  get '/search' => 'item#search'
  post '/generateBill' => 'item#generate_bill'
  get '/showBill' => 'item#show_bill'
end
