Тестирование маршрута доставки до указанного адреса
> exim -bt alias@localdomain.com

Вывести количество сообщений в очереди
> exim -bpc

Печать списка сообщений в очереди. Выводятся, время постановки в очередь, размер, ID сообщения, отправитель, получатель
> exim -bp

Листинг всех настроек конфигурации
> exim -bP

Эмитировать SMTP транзакцию из командной строки, как если-бы сообщение пришло с указанного IP адреса. При этом будет показано прохождение и срабатывание проверок, фильтров и листов доступа (ACL). На самом деле, никакое сообщение никуда доставлено не будет
> exim -bh 192.168.11.22

Удалить все заблокированные сообщения
> exiqgrep -z -i | xargs exim -Mrm

Удалить все сообщения, старше 5 дней (86400 * 5 = 432000 секунд)
> exiqgrep -o 432000 -i | xargs exim -Mrm
