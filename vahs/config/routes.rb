Rails.application.routes.draw do
  get 'index', to: 'base#index'
  get 'about', to: 'base#about'
  get 'docket', to: 'reports#docket'
  get 'analysis', to: 'reports#analysis'
  get 'fiscalyears', to: 'reports#fiscalyears'
  
  post 'fiscalyears', to: 'reports#update_fiscalyears'
  post 'docket', to: 'reports#getDocket'
  post 'analysis', to: 'reports#getAnalysis'

  
  root "base#index"
  
end
