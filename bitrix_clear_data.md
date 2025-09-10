Очистка данных копий
===


```php

$_SERVER["DOCUMENT_ROOT"] = realpath(dirname(__FILE__) . "/../../"); // Выставить верное значение если необходимо запускать скрипт через консоль
define("NO_KEEP_STATISTIC", true);
define("NOT_CHECK_PERMISSIONS", true);

require($_SERVER["DOCUMENT_ROOT"] . "/bitrix/modules/main/include/prolog_before.php");

\Bitrix\Main\Loader::includeModule("iblock");

ini_set('max_execution_time', 0);
ini_set('memory_limit', '4G');

function _log($msg){
    fwrite(STDOUT,  $msg);
    ob_flush();
    flush();
}

function measure($callback, &$result, ...$args) {
    $time = microtime(true);

    $result = call_user_func($callback, ...$args);

    return round((microtime(true) - $time) * 1000, 2);
}

function clearIblock($filter){
    $lastId = null;
    $iteration = 0;
    
    do {
        unset($rsEl);
    
        if (!empty($lastId)) {
            $filter[">ID"] = $lastId;
        }

        $rsEl = CIBlockElement::GetList(["ID" => "ASC"], $filter, false, [
            "nTopCount" => 10000
        ], [
            "ID"
        ]);
    
        $meanDuration = 0;
        $count = 0;
        while($arEl = $rsEl->GetNext()) {
            $meanDuration += measure([CIBlockElement::class, 'Delete'], $result, $arEl["ID"]);
            $count++;
            $lastId = $arEl["ID"];
            unset($arEl);
        }

        if ($count > 0) 
            $meanDuration /= $count;
    
        gc_collect_cycles();
        $iteration++;
        _log("iteration=$iteration; memory_usage=" . round(memory_get_usage()/1048576, 2) . "Mb" . "; deleted=" . $count . "; mean_delete_time=$meanDuration ms\n");
    } while ((int)$rsEl->SelectedRowsCount() > 0);
}

$orderId = 379850; // заказы до этого id будут удалены
$basketId = 746949; // корзины до этого id буду удалены

// Добавить сюда доп удаление таблиц
$queries = [
    "DELETE FROM ms_csv_import WHERE DATE < '2025-01-01 00:00:00';",
    "DELETE FROM b_sale_order WHERE DATE_INSERT < '2025-01-01 00:00:00';",
    "DELETE FROM b_sale_fuser WHERE DATE_INSERT < '2025-01-01 00:00:00';",
    "DELETE FROM b_sale_order_dlv_basket WHERE BASKET_ID <= $basketId;",
    "DELETE FROM b_sale_order_discount_data WHERE ORDER_ID <= $orderId;",
    "DELETE FROM b_sale_order_payment WHERE ORDER_ID <= $orderId;",
    "DELETE FROM b_sale_order_delivery WHERE ORDER_ID <= $orderId;",
    "DELETE FROM b_sale_order_entities_custom_fields WHERE ENTITY_ID <= $basketId;",
    "DELETE FROM b_sale_basket WHERE ORDER_ID <= $orderId;",
    "DELETE FROM b_sale_order_props_value WHERE ORDER_ID <= $orderId;",
    "DELETE FROM b_sale_basket_props WHERE BASKET_ID <= $basketId;",
    "DELETE FROM b_sale_basket_props_17_12 WHERE BASKET_ID <= $basketId;",
    "DELETE FROM b_sale_order_change;",
    "DELETE FROM b_sender_posting_recipient;",
    "DELETE FROM b_mail_log;",
    "DELETE FROM b_sale_exchange_log;",
    "DELETE FROM b_sale_order_change;",
    "DELETE FROM b_sender_posting_read;",
    "DELETE FROM b_mail_spam_weight;",
    "DELETE FROM b_mail_msg_attachment;",
    "DELETE FROM b_posting_email;",
    "DELETE FROM b_sender_message_field;",
    "DELETE FROM b_sender_contact;",
    "DELETE FROM b_sender_posting_click;",
];

global $DB;


foreach($queries as $query){
    _log( "start query=$query\n");
    $duration = measure([$DB, 'Query'], $result, $query);
    _log("end time=$duration ms\n");
}

// удаление по дате создания
clearIblock([
    "IBLOCK_ID" => [73, 74, 75, 110],
    "<DATE_CREATE" => (new \Bitrix\Main\Type\DateTime())->add("- 6 month")
]);

// удаление по активности
clearIblock([
    "IBLOCK_ID" => [210, 63],
    "ACTIVE" => "N"
]);

```
