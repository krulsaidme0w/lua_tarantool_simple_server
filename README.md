# Tarantool http server with database
---
## Installation

```sh
docker-compose -f docker-compose.yml up
```

---

## API:
 - ##### `POST     /kv       body: {key: "test", "value": {SOME ARBITRARY JSON}} `
 - ##### `PUT      kv/{id}   body: {"value": {SOME ARBITRARY JSON}}`
 - ##### `GET      kv/{id} `
 - ##### `DELETE   kv/{id}`
---

## Task:
##### 1) скачать/собрать тарантул ✔
##### 2) реализовать на нем kv-хранилище доступное по http ✔
##### 3) выложить на гитхаб ✔
##### 4) задеплоить где-нибудь в публичном облаке, чтобы мы смогли проверить работоспособность (или любым другим способом) ✔

### requirements:
 - ##### POST  возвращает 409 если ключ уже существует ✔
 - ##### POST, PUT возвращают 400 если боди некорректное ✔
 - ##### PUT, GET, DELETE возвращает 404 если такого ключа нет ✔
 - ##### все операции логируются ✔  (дефолтное логгирование tarantool-а, сам не писал `log.info` и тп)

---
