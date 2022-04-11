# otus-bash

Написать скрипт для крона, который раз в час присылает на заданную почту:

1. X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
2. Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
3. все ошибки c момента последнего запуска;
4. cписок всех кодов возврата с указанием их кол-ва с момента последнего запуска. В письме должно быть прописан обрабатываемый временной диапазон и должна быть реализована защита от мультизапуска.

В письме должен быть прописан обрабатываемый временной диапазон и должна быть реализована защита от мультизапуска.

Указать в Vagrantfile необходимый email

## HW 8

- `vagrant up`

- `vagrant ssh`

- Подождать задачу cron или `sh /vagrant/bashscript.sh  example@example.com 5 10`

- `cat /var/spool/mail/vagrant`

```
Logs scanned from 11/Apr/2022:17 to 11/Apr/2022:18.

Requests from IP addresses:

     13 172.20.0.1
     12 88.200.246.221
     10 5.255.253.144
      8 66.249.70.86
      5 83.23.252.254

Requested URLs:

      9 /wp-admin/admin-ajax.php
      7 /wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0
      4 /wp-json/pwa-for-wp/v2/pwa-manifest-json
      3 /?wc-ajax=get_refreshed_fragments
      2 /wp-content/themes/woodmart/fonts/fontawesome-webfont.woff2?v=4.7.0
      2 /wp-content/plugins/yith-woocommerce-wishlist/assets/fonts/fontawesome-webfont.woff2?v=4.7.0
      2 /product-category/transmissiya/korobki-pereklyucheniya-peredach-kpp/kalina-kpp/amp
      2 /feed/turbo/?paged=3
      1 /wp-json/wc-analytics/products/reviews?page=1&per_page=1&status=hold&_locale=user
      1 /wp-cron.php?doing_wp_cron=1626788974.9932949542999267578125

Errors:

34.121.79.58 - - [11/Apr/2022:17:00:38 +0400] "GET /blog/ HTTP/2.0" 404 33896 "-" "Mozilla/5.0 (Linux; Android 5.1.1; SM-J111F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.90 Mobile Safari/537.36"
34.121.79.58 - - [11/Apr/2022:17:00:52 +0400] "GET /home/ HTTP/2.0" 301 0 "-" "Mozilla/5.0 (Linux; Android 5.1.1; SM-J111F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.90 Mobile Safari/537.36"
34.121.79.58 - - [11/Apr/2022:17:01:10 +0400] "GET /bk/ HTTP/2.0" 404 33892 "-" "Mozilla/5.0 (Linux; Android 5.1.1; SM-J111F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.90 Mobile Safari/537.36"
66.249.70.86 - - [11/Apr/2022:17:02:12 +0400] "GET /product/zashhita-perednego-bampera-dvojnaya-51-51mm-iz-nerzhaveyushhej-stali-dlya-lada-vesta-sv-kross/amp/ HTTP/1.1" 301 5 "-" "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.90 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
172.20.0.1 - - [11/Apr/2022:17:10:19 +0400] "POST /wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0 HTTP/1.1" 499 0 "https://test.ru/wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0" "WordPress/5.5.5; https://test.ru"
172.20.0.1 - - [11/Apr/2022:17:12:33 +0400] "POST /wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0 HTTP/1.1" 499 0 "https://test.ru/wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0" "WordPress/5.5.5; https://test.ru"
5.255.253.144 - - [11/Apr/2022:17:27:12 +0400] "GET /product/tsu-farkop-na-lada-vesta-sw-cross-2017-01411501 HTTP/1.1" 404 33925 "-" "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"
95.163.255.122 - - [11/Apr/2022:17:32:49 +0400] "GET /product/zashhita-porogov-truba-d-76-iz-nerzhaveyushhej-stali-dlya-greatwall-hover-h5-2010-2017-g HTTP/1.1" 301 162 "-" "Mozilla/5.0 (compatible; Linux x86_64; Mail.RU_Bot/2.0; +http://go.mail.ru/help/robots)"
172.20.0.1 - - [11/Apr/2022:17:37:01 +0400] "POST /wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0 HTTP/1.1" 499 0 "https://test.ru/wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0" "WordPress/5.5.5; https://test.ru"
141.8.142.85 - - [11/Apr/2022:17:39:54 +0400] "GET / HTTP/1.1" 301 162 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"
172.20.0.1 - - [11/Apr/2022:17:42:13 +0400] "POST /wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0 HTTP/1.1" 499 0 "https://test.ru/wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0" "WordPress/5.5.5; https://test.ru"
66.249.70.88 - - [11/Apr/2022:17:44:32 +0400] "GET /rick-store/25611olud10003865.htm HTTP/1.1" 404 33892 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
172.20.0.1 - - [11/Apr/2022:17:51:59 +0400] "POST /wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0 HTTP/1.1" 499 0 "https://test.ru/wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0" "WordPress/5.5.5; https://test.ru"
66.249.70.86 - - [11/Apr/2022:17:55:21 +0400] "GET /re-vida/13829kmxl02-ror00jt-ind.htm HTTP/1.1" 404 33908 "-" "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.90 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
172.20.0.1 - - [11/Apr/2022:17:55:47 +0400] "POST /wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0 HTTP/1.1" 499 0 "https://test.ru/wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0" "WordPress/5.5.5; https://test.ru"
172.20.0.1 - - [11/Apr/2022:17:59:25 +0400] "POST /wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0 HTTP/1.1" 499 0 "https://test.ru/wp-admin/admin-ajax.php?action=wp_example_process&nonce=e178ad54c0" "WordPress/5.5.5; https://test.ru"

Response codes:

     57 200
     11 499
      5 404
      4 301
```