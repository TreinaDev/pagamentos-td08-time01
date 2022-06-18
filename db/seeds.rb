# frozen_string_literal: true

puts '--------------------------------------------------'
puts 'Start "seeds"'
puts '--------------------------------------------------'

puts '------------ creating Admins ---------------------'
pending = Admin.create!(full_name: 'Admin', cpf: '24365465686',
                        email: 'admin@userubis.com.br', password: '123456',
                        status: 0)
active = Admin.create!(full_name: 'Admin Ativo', cpf: '06001818398',
                       email: 'adminativo@userubis.com.br', password: '123456',
                       status: 5)
Admin.create!(full_name: 'Felipe Ferreira', cpf: '64262244563',
              email: 'felipe@userubis.com.br', password: '123456',
              status: 5)

puts '------------ creating AdminPermissions -----------'
AdminPermission.create!(admin_id: pending.id, active_admin: active.id)

puts '------------ creating ClientCategory -------------'
category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
ClientCategory.create!(name: 'Ouro', discount_percent: 10)

puts '------------ creating Client ---------------------'
client_one = Client.create!(client_type: 0, client_category_id: category.id)
client_two = Client.create!(client_type: 5, client_category_id: category.id)

puts '------------ creating ClientPerson ---------------'
ClientPerson.create!(full_name: 'Luiz Santos', cpf: '12345678999', client_id: client_one.id)

puts '------------ creating ClientCompany --------------'
ClientCompany.create!(company_name: 'ACME LTDA', cnpj: '12345678912345', client_id: client_two.id)

puts '--------------------------------------------------'
puts 'Finished "seeds"'
puts '--------------------------------------------------'