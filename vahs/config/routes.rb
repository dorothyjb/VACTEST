Rails.application.routes.draw do
  get '/', to: 'base#index'
  get '/index', to: 'base#index'

  root "base#index"

  #get 'docket', to: 'docket#get'
  #post 'docket', to: 'docket#post'

  #get 'analysis', to: 'analysis#get'
  #post 'analysis', to: 'analysis#post'

  #get 'fiscalyears', to: 'docket#fiscalyears'
  #post 'fiscalyears', to: 'docket#update_fiscalyears'

  namespace :rms, as: :rms do
    scope :employee, as: :employee do
      get '/', to: 'employee#index'

      get '/new', to: 'employee#new'
      post '/new', to: 'employee#create'

      get '/edit/:id', to: 'employee#edit', as: :edit
      post '/edit/:id(.:format)', to: 'employee#update'

      get '/search', to: 'employee#search'
      post '/search', to: 'employee#search'

      get '/locator', to: 'employee#locator'
      post '/locator', to: 'employee#locator'

      get '/picture/(:id)', to: 'employee#picture'

      get '/status_select/(:id)', to: 'employee#status_select'
      
      get '/schedule_select/(:id)', to: 'employee#schedule_select'
      get '/attachment_form', to: 'employee#attachment_form'
      get '/award_form', to: 'employee#award_form'

      scope :award do
        get '/:id/edit', to: 'award#edit'
        get '/:id/delete', to: 'award#delete'
      end

      scope :attachment do
        get '/:id/edit', to: 'attachment#edit'
        get '/:id/delete', to: 'attachment#delete'
        get '/:id/undo', to: 'attachment#undo'
      end
    end

    scope :applicant, as: :applicant do
      get '/', to: 'applicant#index'
      post '/', to: 'applicant#create'
      
      get '/new', to: 'applicant#new'
      post '/new', to: 'applicant#create'
      
      get '/:id/edit', to: 'applicant#edit', as: :edit
      post '/:id/edit', to: 'applicant#update'
      get '/:id/copy', to: 'applicant#copy', as: :copy
      delete '/:id', to: 'applicant#delete', as: :delete

      get '/new_search/:searchtype', to: 'applicant#new_search'
    
      get '/(:id)/status_select/', to: 'applicant#status_select'
    
      get 'attachment_form', to: 'applicant#attachment_form'

      scope :attachment2 do
        get '/:id/edit', to: 'attachment2#edit'
        get '/:id/delete', to: 'attachment2#delete'
        get '/:id/undo', to: 'attachment2#undo'
      end
    end

    scope :training, as: :training do
      delete '/:id', to: 'training#delete'
      get '/:id/edit', to: 'training#edit', constraints: { id: /\d+/ }
    end

    scope :attachment, as: :attachment do
      get '/:id', to: 'attachment#download'
    end

    scope :reports, as: :reports do
      get '/', to: 'reports#index'

      get '/pipeline', to: 'reports#pipeline'

      get '/snapshot', to: 'reports#snapshot'
      post '/snapshot', to: 'reports#snapshot_export'

      get '/fte(.:format)', to: 'reports#fte'
      post '/fte', to: 'reports#fte_export'

      get '/paid_exception', to: 'reports#paid_exception'
    end

    scope :organization, as: :organization do
      get '/', to: 'organization#index'

      get '/office(.:format)', to: 'organization#office'
      get '/division(.:format)', to: 'organization#division'
      get '/branch(.:format)', to: 'organization#branch'
      get '/unit(.:format)', to: 'organization#unit'
      get '/org_code(.:format)', to: 'organization#org_code'
    end
  end

  scope :admin do
    get '/roles', to: 'admin#roles', as: :admin_roles
  end

  get 'contact_us', to: 'base#contact_us'
  get 'resource_guide', to: 'base#resource_guide'
end
