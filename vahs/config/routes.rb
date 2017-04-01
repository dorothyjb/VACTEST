Rails.application.routes.draw do
  get 'index', to: 'base#index'
  get 'about', to: 'base#about'

  get 'docket', to: 'docket#get'
  post 'docket', to: 'docket#post'

  get 'analysis', to: 'analysis#get'
  post 'analysis', to: 'analysis#post'

  get 'fiscalyears', to: 'docket#fiscalyears'
  post 'fiscalyears', to: 'docket#update_fiscalyears'
  
  root "base#index"
end
