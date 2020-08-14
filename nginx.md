nginx-это http сервер, используется как прокси-сервер, почтовый сервер и TCP/UDP сервер общего назначения.

запуск службы nginx 
 >systemctl start nginx   //старт nginx
 >systemctl stop nginx  //остановка nginx
 >systemctal restart nginx  //полный рестарт nginx (главный процесс тоже перезапускается)
 
сигналы которые можно передать nginx 
  1 - stop - быстрое завершение 
  2 - quit - плавное завершение
  3 - reload - перезагрузка конфигурации и процессов worker`ов
  4 - reopen - переоткрытие log-файлов
для передачи сигналов:
  >nginx -s <сигнал>
  
проверка конфигурационного файла nginx
  >nginx -t
  
Основные директивы nginx
  
  user <пользователь>;  //указывает от какого пользователя будет работать nginx
  worker_process <количество воркеров>; //количество воркер процессов если не задан, по умолчанию кол-во процессов равно кол-ву ядер процессора
  error_log <путь к файлу лога> <уровень уведомлений>;  //задает настройки для логов ошибок возможные уровни уведомлений [ debug | info | notice | warn | error | crit ]
  access_log; //тоже что и error_log, только для доступов  
  worker_connections <количество соединений>;   //задает количество возможных подключений к воркеру (общее число подключений = worker_process * worker_connections) указывается в блоке events
  use <модуль работы с событиями>;  //указывает как обрабатывать события [ kqueue | epoll | /dev/poll | select | poll ]
  sendfile [on | off];  //позволяет отправлять данные по сети не копируя в адресное пространство nginx
  keepalive_timeout <время в секундах>; //максимальное время поддержания keepalive соединения, если пользователь по нему ничего не запрашивает
  proxy_buffers 8 64k;  //размер буфера при проксировании, следует устанавливать не меньше чем ответ от бэкэнд сервера
  proxy_intercept_errors on;  //включает перехват ошибок которые выше 300 кода и эти ошибки будут обрабатываться директивой error_page
  error_page <список ошибок через пробел> <сервер ошибок>;  //для указанных ошибок переводит запрос на сервер ошибок
  proxy_connect_timeout 1s; //задает максимальное время ожидания от сервера на который приксируется запрос
  proxy_read_timeout 3s;  //максимальное время чтения ответа от сервеа на который проксируется запрос
  proxy_send_timeout 3s;  //максимальное время отправки запроса на сервер на который проксируется запрос
  include /spool/users/nginx/*.conf;  //позволяет подключать конфигурационные файлы
  server_name <имена сервера>; //устанавливает имя сервера в порядке важности
  listen <адрес с портом или порт>; //устанавливает адрес и порт который будет слушать виртуальный сервер
  charset utf-8;  //устанавливает кодировку по умолчанию
  client_max_body_size 1m;  //максимальный размер тела запроса от пользователя
  set $www_root "/data/myserver/root";  // позваоляет установить переменную
  gzip on;  //включает сжатие данных перед отправкой
  gzip_min_length 1024; //минимальный размер файлов для сжатия
  gzip_proxied expired no-cache no-store private auth;
  gzip_types text/plain application/xml; 
  root $root/loc; //устанавливает корневую директорию для блоков location или server
  proxy_pass <127.0.0.1:9000>; //указывает на какой адрес проксировать запрос
  fastcgi_pass <127.0.0.1:8080 | unix:/var/run/php/user.sock>;  //проксировать на fastcgi сервер
  index <список индексных файлов>;  //устанавливает для блока индексную страницу по мере важности 
  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; //устанавливает параметр для fast cgi сервера
  try_files <try:папка или файл> <catch:файл или папка>; //проверяет существует ли искомая папка или фалй, если есть то отдает его, если нету то отдает второй файл или пупку
  
Пример файла конфигурации nginx для сервера на php с framework (конфигурация тестовая описует суть как должен быть устроен конфигурационный файл, конфигурация не тестировалась!!!)

user www-data;
worker_process 2;

events{
  use kqueue;
  worker_connections 1024;
}

http{
  server{
    server_name my-server.com;
    listen 80;
    index index.html index.php;
    root
    set $root "/var/www/my-server.com";
    
    location ~ /.php$ {
      root $root/www;
      try_files $uri framework;
    }
    
    location framework{
      fastcgi_pass 127.0.0.1:8080;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include fastcgi_params;
      #fastcgi_pass unix:/var/run/php/php.sock; 
    }
    
    location download{
      root $root/download;
      try_files $uri $root/www/index.php;
    }
    
  }
}
