FactoryBot.define do
  factory :admin do
    email { %w[example@userubis.com.br testexample@userubis.com.br].sample }
    password { %w[984984498 testpassword].sample }
    full_name { ['João Santos', 'Yuri'].sample }
    cpf { %w[000.000.000-20 510.695.623-20].sample }
  end
end
