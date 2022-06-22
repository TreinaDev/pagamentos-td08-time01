# API - PAGAMENTO

## Registrando Cliente
![POST](https://img.shields.io/badge/-POST-blue "POST")`/api/v1/clients`

#### Parâmetros - Pessoa Física:
```
        {
          "client": {
          "client_type": "client_person",
          "client_person_attributes": {
            "full_name": "Zezinho",
            "cpf": "06001818398"
          }
        }
      }
```
####  Resposta de Sucesso:
![201: Created](https://img.shields.io/badge/Code:%20201-CREATED-green "201: Created")  
```
  {
    "client_type": "client_person",
    "balance": 0.0,
    "client_person": {
        "full_name": "Zezinho",
        "cpf": "060.018.183-98"
    }
}
 ```
 
 #### Parâmetros - Pessoa Jurídica:
 
 ```
      {
        "client": {
          "client_type": "client_company",
          "client_company_attributes": {
            "company_name": "ACME LTDA",
            "cnpj": "07638546899424"
          }
        }
      }
 ```
 
 ####  Resposta de Sucesso:
![201: Created](https://img.shields.io/badge/Code:%20201-CREATED-green "201: Created")  
```
 {
    "client_type": "client_company",
    "balance": 0.0,
    "client_company": {
        "company_name": "ACME LTDA",
        "cnpj": "07.638.546/8994-24"
    }
}
 ```
 
#### Resposta de Falha - Faltando parâmetro:
![422: Unprocessed ](https://img.shields.io/badge/code%3A%20422-%20UNPROCESSABLE%20ENTITY-red)

Resposta retorna mensagem de erro por não ser enviado parâmetros necessários. Exemplo:
``` 
#### Pessoa Jurídica:
{
    "message": "A validação falhou: Tipo de cliente não pode ficar em branco, Razão social não pode ficar em branco, CNPJ não pode ficar em branco, CNPJ não é válido"
}

#### Pessoa Física:
{
    "message": "A validação falhou: Tipo de cliente não pode ficar em branco, Nome completo não pode ficar em branco, CPF não pode ficar em branco, CPF não é válido"
}
```

#### Resposta de Falha - Requisição ruim:
![400: Bad request ](https://img.shields.io/badge/code%3A%20400-BAD%20REQUEST-red)

Resposta retorna mensagem em requisição ruim
``` 
{
    "message": "A validação falhou: sintaxe inválida"
}
```

## Exibindo Informações do cliente
![GET](https://img.shields.io/badge/-GET-blue)`/api/v1/clients_info`

#### Parâmetros - Pessoa Física:
```
  { "registration_number": "06001818398" }
```
####  Resposta de Sucesso:
![200: OK](https://img.shields.io/badge/code%3A%20200-OK-green)  
```
{
    "client_balance": {
        "balance": 0.0
    },
    "client_info": {
        "full_name": "Zezinho",
        "cpf": "060.018.183-98"
    }
}

 ```

#### Parâmetros - Pessoa Jurídica:
```
  { "registration_number": "07638546899424" }
```
####  Resposta de Sucesso:
![200: OK](https://img.shields.io/badge/code%3A%20200-OK-green)  
```
{
    "client_balance": {
        "balance": 0.0
    },
    "client_info": {
        "company_name": "ACME LTDA",
        "cnpj": "07.638.546/8994-24"
    }
}
 ```
 
 #### Resposta de Falha - Não encontrado:
![404: Not Found ](https://img.shields.io/badge/code%3A%20404-NOT%20FOUND-red)

Resposta retorna mensagem em caso CNPJ ou CPF não encontrem um cliente
``` 
{
    "errors": "Cliente não encontrado"
}
```

