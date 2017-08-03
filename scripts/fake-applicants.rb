#! /usr/bin/env ruby

require '../vahs/config/environment'

# generated from http://listofrandomnames.com/
LIST_OF_NAMES=<<EOF.freeze
Bree Vowell
Lyndon Claunch
Neda Manahan
Johanna Bergerson
Jeanelle Wait
Destiny Whorley
Kraig Lafayette
Mathew Strzelecki
Azucena Greaver
Sheba Hinson
Polly Birdsall
Liane Sweetser
Dominic Diebold
Anjelica Kurtz
Lashawnda Partee
Shon Milo
Sparkle Stiefel
Chau Hogsett
Ernesto Felice
Major Yelle
Lula Hereford
Nelle Parkin
Jackelyn Stutz
Cammy Sulik
Judi Morelock
Luna Meininger
Adelaide Brocious
Etsuko Polinsky
Willette Joly
Porter Amburgey
Rea Clabaugh
Xenia Daye
Elena Clary
Emmanuel Nishimoto
Kermit Carder
Jacqui Brannock
Vern Hevey
Dusty Douthitt
Anton Cambra
Cammie Firkins
Emmie Ristau
Rudy Balducci
Loriann Sattler
Janetta Kroner
Jada Kamin
Farah Commander
Creola Tipton
Marjory Lucena
Carlita Baxley
Gertha Mennenga
EOF

LIST_OF_NAMES.split(/\n/).each do |first_last|
  firstname, lastname = first_last.upcase.split(/ /)
  applicant = Bvadmin::EmployeeApplicant.find_or_create_by(fname: firstname, lname: lastname)
  applicant.save
end
