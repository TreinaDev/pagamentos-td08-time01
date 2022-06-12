puts
puts '--------------------------------------------------'
puts 'Start "seeds"'
puts '--------------------------------------------------'
puts

puts '-------------- creating Admins -------------'

Admin.create!(full_name: 'José Arantes', cpf: '24365465686',
              email: 'jose@userubis.com.br', password: '123464',
              status: 0)

active = Admin.create!(full_name: 'Lucio Santos', cpf: '06001818398',
              email: 'lucio22@userubis.com.br', password: '239102',
              status: 5)

Admin.create!(full_name: 'Felipe Ferreira', cpf: '64262244563',
              email: 'feferreira556@userubis.com.br', password: '203942',
              status: 5)

puts '-------------- creating AdminPermissions -------------'

AdminPermission.create!(admin_id: 1, active_admin: active.id)

puts
puts '--------------------------------------------------'
puts 'Finished "seeds"'
puts '--------------------------------------------------'
puts