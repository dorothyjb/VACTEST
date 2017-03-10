class Vacols::Record < ActiveRecord::Base
  self.abstract_class = true

  #establish_connection "local_vacols_#{Rails.env}".to_sym
end
