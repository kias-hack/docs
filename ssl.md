### Некоторые ключи и их значение в openssl

* `-noout` - вывод в терминал а не в файл
* `-text` - выводим данные в текстовом виде
* `-in` - файл который является входом
* `-out` - файл куда будет записывать результат
* `req` - это генерация запросов на подпись сертификата, но если задать ключ `-x509`, это означает, что нужно генерировать самоподписанный сертификат
* `-newkey <type>:<bit>` - если еще нету ключа, мы добавляем данный параметр, что бы ключ был создан автоматически. Указываем параметры ключа
* `-days <int>` - кол-во дней, в течении которых будет действовать данный сертификат
* `-keyout <dir>` - параметр нужен, так как мы указали newkey и генерируем новый ключ. Указываем в какой фал положим ключ
* `-out <dir>` - вывод для сертификата

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

Достать цепочку из pfx файла

> openssl pkcs12 -in `certificate.pfx` -cacerts -nokeys -chain

Достать ключ и сертификат

> openssl pkcs12 -in `certificate.pfx` -nokeys -clcerts -noout

> openssl pkcs12 -in `certificate.pfx` -nocerts -nodes

# Выпуск самоподписанного сертификата letsencrypt

Для выпуска сертификата используется команда

> certbot certonly --webroot -w `web_path` -d `domain`

Где:
* `web_path` - путь к директории с сайтом (если используется система ispmanager, тогда этот путь должен быть /usr/local/mgr5/www/letsencrypt/, т.к. панель уже проставила автоматический редирект на путь который генерирует скрипт получения сертификата)
* doamin - домен для которого необходимо получить сертификат

