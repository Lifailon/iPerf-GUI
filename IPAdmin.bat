@echo off
chcp 65001
:start
cls

set IPAdmin=.\IPAdmin.bat
set iperf=.\soft\iperf3.exe
set PsPing=.\soft\psping.exe
set log=.\log\
set traffic=1Gb
set sec=10
rem Диапазон сканирования 4-го актета:
set start=1
set end=50

echo Меню:
echo 1. Запустить сервер на порту 5201 (default)
echo 2. Запустить сервер на указанном порту
echo 3. Подключиться к серверу клиентом
echo 4. Проверить порт удаленного сервера
echo 5. Открыть порт в Firewall (Run as administrator)
echo 6. Сканер сети

set /P num="Введите пункт меню: "

if not defined num (cls & echo Не выбран пункт меню, введите номер & pause & goto start)

if %num% equ 1 cls
if %num% equ 1 echo Адрес(а) сервера:
if %num% equ 1 ipconfig | find "IPv4 Address"
if %num% equ 1 (%iperf% -s , exit 0)

if %num% equ 2 set /P port-server="Введите номер порта: "
if %num% equ 2 cls
if %num% equ 2 echo Адрес(а) сервера:
if %num% equ 2 ipconfig | find "IPv4 Address"
if %num% equ 2 (%iperf% -s -p %port-server% , exit 0)

if %num% equ 4 set /P ip="Введите адрес сервера: "
if %num% equ 4 set /P port-client="Введите номер порта: "
if %num% equ 4 cls
if %num% equ 4 %PsPing% -n 1 %ip%:%port-client%
if %num% equ 4 (pause & goto start)

if %num% equ 5 set /P port-fw="Введите номер порта или диапазон: "
if %num% equ 5 cls
if %num% equ 5 netsh advfirewall firewall add rule name="%port-fw%-IPAdmin" dir=in action=allow localport=%port-fw% protocol=TCP enable=yes
if %num% equ 5 netsh advfirewall firewall show rule name="%port-fw%-IPAdmin"
if %num% equ 5 (pause & goto start)

if %num% equ 6 cls
if %num% equ 6 set /P ip="Введите 3-й актет подсети: 192.168."
if %num% equ 6 echo Сканирование: 192.168.%ip%.%start%-192.168.%ip%.%end%
if %num% equ 6 (
for /L %%i in (%start%,1,%end%) do @ping 192.168.%ip%.%%i -n 1 -w 50 -l 1 -i 10 | find "Reply" >> .\ip_temp.txt
)

if %num% equ 6 echo Список доступных адресов:
if %num% equ 6 (
for /F "delims=.: tokens=4" %%p in (.\ip_temp.txt) do echo 192.168.%ip%.%%p >> ip.txt
)
if %num% equ 6 del .\ip_temp.txt
if %num% equ 6 type .\ip.txt

if %num% equ 6 set /P port-client="Введите номер порта для сканирования: "
if %num% equ 6 (
for /F %%s in (.\ip.txt) do %PsPing% -n 0 %%s:%port-client% | find "from 192.168"
)
if %num% equ 6 (del .\ip.txt & pause & goto start)

if %num% equ 3 set /P ip="Введите адрес сервера: "

if %num% equ 3 cls
if %num% equ 3 echo Подключение к серверу: %ip%
if %num% equ 3 echo 1. Проверка скорости upload
if %num% equ 3 echo 2. Проверка скорости download
if %num% equ 3 echo 3. Проверка скорости upload на указанном порту
if %num% equ 3 echo 4. Проверка скорости download на указанном порту
if %num% equ 3 echo 5. Проверка скорости upload используя несколько потоков
if %num% equ 3 echo 6. Проверка скорости download используя несколько потоков
if %num% equ 3 echo 7. Проверка скорости upload используя несколько потоков с выводом в лог-файл
if %num% equ 3 echo 8. Проверка скорости download используя несколько потоков с выводом в лог-файл

if %num% equ 3 set /P num2="Выберите действие из списка: "

if %num% geq 7 (cls & echo Пунк меню отсутствует в списке & pause & goto start)

if not defined num2 (cls & echo Не выбран пункт меню, введите номер & pause & goto start)

if %num2% equ 1 cls
if %num2% equ 1 %iperf% -c %ip% -n %traffic%
if %num2% equ 1 pause & exit 0

if %num2% equ 2 cls
if %num2% equ 2 %iperf% -c %ip% -n %traffic% -R
if %num2% equ 2 pause & exit 0

if %num2% equ 3 set /P port-client="Введите номер порта: "
if %num2% equ 3 cls
if %num2% equ 3 %iperf% -c %ip% -n %traffic% -p %port-client%
if %num2% equ 3 pause & exit 0

if %num2% equ 4 set /P port-client="Введите номер порта: "
if %num2% equ 4 cls
if %num2% equ 4 %iperf% -c %ip% -n %traffic% -R -p %port-client%
if %num2% equ 4 pause & exit 0

if %num2% equ 5 set /P port-client="Введите номер порта: "
if %num2% equ 5 set /P streams="Введите количество потоков: "
if %num2% equ 5 cls
if %num2% equ 5 %iperf% -c %ip% -n %traffic% -p %port-client% -P %streams% -i %sec%
if %num2% equ 5 pause & exit 0

if %num2% equ 6 set /P port-client="Введите номер порта: "
if %num2% equ 6 set /P streams="Введите количество потоков: "
if %num2% equ 6 cls
if %num2% equ 6 %iperf% -c %ip% -n %traffic% -R -p %port-client% -P %streams% -i %sec%
if %num2% equ 6 set info = info

if %num2% equ 7 set /P port-client="Введите номер порта: "
if %num2% equ 7 set /P streams="Введите количество потоков: "
if %num2% equ 7 cls
if %num2% equ 7 %iperf% -c %ip% -n %traffic% -p %port-client% -P %streams% -i %sec% --logfile %log%%ip%_%date%_%time%.log
if %num2% equ 7 pause & exit 0

if %num2% equ 8 set /P port-client="Введите номер порта: "
if %num2% equ 8 set /P streams="Введите количество потоков: "
if %num2% equ 8 cls
if %num2% equ 8 %iperf% -c %ip% -n %traffic% -R -p %port-client% -P %streams% -i %sec% --logfile %log%%ip%_%date%_%time%.log
if %num2% equ 8 pause & exit 0

if %num2% geq 9 (cls & echo Пунк меню отсутствует в списке & pause & goto start)