Скрипт для создания бэкапа без определенных таблиц
====

Исключаются рассылки, статистика, поисковая индексация, логи писем, логи событий и пользовательские сессии 

```shell
#!/bin/bash
PASSWORD=
HOST=
USER=
DATABASE=
DB_FILE=dump.sql
EXCLUDED_TABLES=(	
b_form_result_answer
b_perf_sql
b_perf_component
b_perf_hit
b_perf_test
b_perf_cache
b_perf_cache_hitrate
b_perf_cluster
b_perf_error
b_perf_history
b_perf_index_ban
b_perf_index_complete
b_perf_index_suggest
b_perf_index_suggest_sql
b_perf_sql_backtrace
b_perf_tab_column_stat
b_perf_tab_stat
b_perf_table
b_sender_posting_recipient
b_sender_posting_click
b_sender_posting_read
b_sender_contact
b_sender_contact_list
b_sender_mailing_chain_group
b_sender_posting_unsub
b_sender_message_field
b_sender_mailing_subscription
b_sender_posting
b_sender_message
b_sender_mailing_chain
b_sender_message_utm
b_sender_posting_thread
b_sender_group
b_sender_group_connector
b_sender_group_counter
b_sender_group_queue
b_sender_mailing_group
b_sender_permission
b_sender_list
b_sender_mailing
b_sender_preset_template
b_sender_file_info
b_sender_role_permission
b_sender_file
b_sender_role
b_sender_mailing_trigger
b_sender_abuse
b_sender_agreement
b_sender_call_log
b_sender_counter
b_sender_counter_daily
b_sender_group_data
b_sender_group_deal_category
b_sender_group_state
b_sender_group_thread
b_sender_mailing_attachment
b_sender_queue
b_sender_role_access
b_sender_role_relation
b_sender_timeline_queue
b_stat_hit
b_stat_session
b_stat_guest
b_stat_page
b_stat_adv_guest
b_stat_path
b_stat_page_adv
b_stat_path_adv
b_stat_city_ip
b_stat_searcher_hit
b_stat_event_list
b_stat_city_day
b_stat_phrase_list
b_stat_referer_list
b_stat_day_site
b_stat_country_day
b_stat_event_day
b_stat_day
b_stat_referer
b_stat_adv_event_day
b_stat_session_data
b_stat_city
b_stat_adv_day
b_stat_event
b_stat_adv_event
b_stat_searcher_day
b_stat_path_cache
b_stat_country
b_stat_searcher
b_stat_adv
b_stat_searcher_params
b_stat_browser
b_stat_adv_searcher
b_perf_tab_stat
b_stat_adv_page
b_stat_ddl
b_search_phrase
b_search_content_stem
b_search_content_title
b_search_content
b_search_content_site
b_search_content_text
b_search_stem
b_search_content_right
b_search_tags
b_search_content_param
b_search_suggest
b_search_user_right
b_search_content_freq
b_search_custom_rank
b_event_log
b_event
b_user_session
b_subscription
b_subscription_rubric
)
IGNORED_TABLES_STRING=''
for TABLE in "${EXCLUDED_TABLES[@]}"
do :
   IGNORED_TABLES_STRING+=" --ignore-table=${DATABASE}.${TABLE}"
done

echo "Dump structure"
mysqldump --host=${HOST} --user=${USER} --password=${PASSWORD} --single-transaction --no-data --routines ${DATABASE} > ${DB_FILE}
echo "Dump content"
mysqldump --host=${HOST} --user=${USER} --password=${PASSWORD} ${DATABASE} --no-create-info --skip-triggers ${IGNORED_TABLES_STRING} >> ${DB_FILE}
```

Скрипт по формированию списка таблиц из поиска по таблицам в админке
===

Выполнять на странице /bitrix/admin/perfmon_tables.php?lang=ru

```javascript
Array.from(document.querySelectorAll("table.adm-list-table tbody tr td:nth-child(3)")).map(e => e.innerText).join("\n")
```
