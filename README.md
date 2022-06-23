# API de pagamentos
Este projeto é uma API de pagamentos desenvolvido no `TreinaDev - Equipe 1` e tem como objetivo simular as transações de pagamento que serão requisitadas por um Ecommerce.

`Obs.: Este projeto está em desenvolvimento e a data estimada de conclusão é até o dia 04/07/2022.`

## ⚙️ Requisitos
 - Ruby 3.1.0
 - Rails 7.0.3
 - SQLite3

## 🚀 Instrução
Use o seguinte comando para clonar o repositório:
```sh
git clone git@github.com:TreinaDev/pagamentos-td08-time01.git
```
Rode os comandos 
 - `cd ./pagamentos-td08-time01`
 - `bundle install`
 - `yarn install`
 - `yarn build:css --watch`
 - `rails db:create db:migrate db:seed`
 - `rails s`

## 🧰 Funções de administrador 

Menu
 - `Categoria de clientes` - Listar e cadastrar as categorias e suas respectivas taxas de bonus.
 - `Configurações` - Configura um limite máximo de compras de rubi nas últimas 24h.
 - `Taxa de câmbio` - Listar e cadastrar taxas de câmbio para conversões de reais/rubis.
 - `Promoções` - Listar e cadastrar promoções e suas respectivas datas de validade.
 - `Transações` - Listar e recusar/aprovar transações pendentes.

## 🔨 API

[Documentação](https://github.com/TreinaDev/pagamentos-td08-time01/blob/main/documentation/documentation.md)


## 👥 Visitante
 - `Taxa de câmbio` - Qualquer visitante pode visualizar a taxa de câmbio.
