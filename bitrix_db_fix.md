Скрипт для автоматического генерирования SQL запросов по исправлению ошибок кодировки таблиц и полей в БД
===

```php
$lines = file($_SERVER["DOCUMENT_ROOT"] . '/convert_db.txt', FILE_IGNORE_NEW_LINES);

foreach($lines as $line){
   if (str_contains($line, 'Кодировка таблицы')) {
       echo preg_replace("!Кодировка таблицы \"(.*?)\" \((.*?)\) отличается от кодировки базы \((.*?)\)!si","ALTER TABLE \\1 CONVERT TO CHARACTER SET \\3 COLLATE \\3_general_ci;",$line);
       echo PHP_EOL;
   }elseif(str_contains($line, 'В таблице')){
       echo preg_replace("!В таблице (.*?) поле (.*?) \"(.*?)\" не соответствует описанию на диске \"(.*?)\"!si","ALTER TABLE `\\1` CHANGE `\\2` \\4;",$line);
       echo PHP_EOL;
   }
}
```
