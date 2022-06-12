# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { %w[example@userubis.com.br testexample@userubis.com.br].sample }
    password { %w[984984498 testpassword].sample }
    full_name { ['João Santos', 'Yuri'].sample }
    cpf { %w[798.203.013-00 773.164.509-67].sample }
  end
end
