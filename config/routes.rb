Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/items/add' => 'item#create'
  get '/search' => 'item#search'
  post '/bills/add' => 'item#generate_bill'
  get '/bill' => 'item#show_bill'
  get '/items' => 'item#list_items'
  get '/bills' => 'item#list_bills'
end
