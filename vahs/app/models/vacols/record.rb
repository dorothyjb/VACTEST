class Vacols::Record < ActiveRecord::Base
  self.abstract_class = true

  #establish_connection "fake_vacols_#{Rails.env}".to_sym
  establish_connection "local_vacols_#{Rails.env}".to_sym
end