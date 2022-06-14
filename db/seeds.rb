# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rails.logger.debug 'Adiciona categoria de clientes - INÍCIO'
ClientCategory.create!(name: 'Bronze', discount_percent: 0)
ClientCategory.create!(name: 'Ouro', discount_percent: 10)
Rails.logger.debug 'Adiciona categoria de clientes - FIM'

Rails.logger.debug 'Adiciona categoria de cliente - INÍCIO'
ClientCategory.create!(name:'Bronze', discount_percent:0)
Rails.logger.debug 'Adiciona categoria de cliente - FIM'

Rails.logger.debug 'Adiciona cliente - INÍCIO'
Client.create!(client_type: 0, client_category_id: 1)
Rails.logger.debug 'Adiciona cliente - FIM'

Rails.logger.debug 'Adiciona cliente pessoal física - INÍCIO'
ClientPerson.create!(full_name: 'Zeca Urubú', cpf: '12345678999', client_id: 1)
Rails.logger.debug 'Adiciona cliente pessoal física - FIM'

puts "Adiciona admin"
Admin.create!(email: 'b@userubis.com.br', password: '123456', full_name: 'TreinaDev Júnior', cpf: '510.695.623-20')