# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Adiciona categoria de clientes - INÍCIO"
ClientCategory.create!(name: "Bronze", discount_percent: 0)
ClientCategory.create!(name: "Ouro", discount_percent: 10)
puts "Adiciona categoria de clientes - FIM"