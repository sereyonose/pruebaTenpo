# pruebaTenpo


Se asume que ya se encuentra logeado en entorno azure y se cuenta con id de suscripcion

```
$ git clone https://github.com/sereyonose/pruebaTenpo
$ cd scripts/terraform
$ modificar azure_subscription_id en terraform.tfvars
$ terraform init
$ terraform apply
```

Luego se puede importar en postman la coleccion de ejemplo ubicada en la carpeta postman o utilizar los formatos de request en archivo curl.txt de la misma carpeta