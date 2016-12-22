Rails.application.routes.draw do
  get 'index', to: 'base#index'
  get 'about', to: 'base#about'
  get 'docket', to: 'reports#docket'
  get 'analysis', to: 'reports#analysis'
  
  post 'docket', to: 'reports#getDocket'
  post 'analysis', to: 'reports#getAnalysis'

  
  root "base#index"
  
end
