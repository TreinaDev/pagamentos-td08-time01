# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts '--------------------------------------------------'
puts 'Start "seeds"'
puts '--------------------------------------------------'

puts '----------------- creating Admins ----------------'
Admin.create!(full_name: 'José Arantes', cpf: '24365465686',
              email: 'jose@userubis.com.br', password: '123464',
              status: 0)
active = Admin.create!(full_name: 'Lucio Santos', cpf: '06001818398',
              email: 'lucio22@userubis.com.br', password: '239102',
              status: 5)
Admin.create!(full_name: 'Felipe Ferreira', cpf: '64262244563',
              email: 'feferreira556@userubis.com.br', password: '203942',
              status: 5)

puts '------------ creating AdminPermissions -----------'
AdminPermission.create!(admin_id: 1, active_admin: active.id)

puts '------------ creating ClientCategory ------------'
ClientCategory.create!(name: "Bronze", discount_percent: 0)
ClientCategory.create!(name: "Ouro", discount_percent: 10)

puts '------------ creating ClientPerson -------------'
client = Client.create!(client_type: 0, client_category_id: 1)

puts '------------ creating ClientPerson -------------'
ClientPerson.create!(full_name: 'Zeca Urubú', cpf: '12345678999', client_id: 1)

puts '--------------------------------------------------'
puts 'Finished "seeds"'
puts '--------------------------------------------------'
