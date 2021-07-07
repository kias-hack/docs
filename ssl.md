### Проверка pem, crt - сертификата вместе с цепочкой (если несколько файлов, объединить в один, сначала сертификат потом цепочка)

> openssl x509 -noout -modulus -in `server.crt` | openssl md5

### Проверка приватного ключа

> openssl rsa -noout -modulus -in `server.key` | openssl md5

### Проверка csr - ключ запроса сертификата

> openssl req -noout -modulus -in `request.csr` | openssl md5

### MD5 у всех должен совпадать

Но для работоспособности должны быть одинаковы сертификат и ключ. CSR может пригодиться если нужно будет продлевать сертификат

=======================================================================

Командами далее можно посмотреть информацию о сертификате и ключе

> openssl x509 -in `sertificate.crt` -text -noout

> openssl rsa -in `server.key` -text -noout

Проверить приватный ключ RSA

> openssl rsa -in `server.key` -check

Посмотреть данные сертификата

> openssl x509 -text < `sertificate.crt`

Показать даты сертификата

> openssl [`x509`, `rsa`] -noout -dates < `sertificate.crt`

Показать сертификат сайта

> openssl s_client -connect `site.ru:443`

Используя прокси

> openssl s_client  -proxy `192.168.103.115:3128` -connect `site.ru:443`

Сгенерировать самоподисанный сертификат

> openssl req -x509 -nodes -newkey rsa:2048 -days 365 -keyout `./key.pem` -out `cert.pem` -subj /C=/ST=/L=/O=/CN=`site.ru` 
=======
Упаковать сертификаты и ключи в pfx формат можно следующей командой

> openssl pkcs12 -inkey `certificate.key` -in `certificate.crt` -export -out `certificate.pfx`

Достать нужные данные из pfx можно следующим образом

> openssl pkcs12 -in `certificate.pfx` -clcerts -nokeys -out `certificate.crt`

> openssl pkcs12 -in `certificate.pfx` -nocerts -out `key-encrypted.key`

Убрать пароль с ключа можно следующим образом

> openssl rsa -in `key-encrypted.key` -out `key-decrypted.key`
