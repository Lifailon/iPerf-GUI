# iPerf-GUI
Internet Performance Graphical User Interface - это графическая (gui WinForms) и руссифицированная версия программы iperf 3.1.3 (Open Source Software). Для установки используется пакет SFX (iPerf-GUI-Install.exe) с расположением в "C:\Program Files\iPerf GUI\" и ярлыком на рабочем столе исполняемого файла запуска программы (упакованный ps2exe). В директории images находится файл шрифтов и используемых иконок, в директории iperf исполняемый файл и его dll. IPAdmin - первая версия программы (bat и ps1).

Особенности:

Динамическое выпадающие меню списка серверов (не нужно перезапускать форму), при добавлении и удалении внесения изменений производится в conf-файл рядом с файлом exe;

Весь вывод программы руссифицирован по средствам Regex с возможностью сохранения вывода в файл txt с временем запуска;

Все ключи программы имеют свои значения по умолчанию, которые можно изменить в gui - порт, тип передачи, кол-во потоков и трафика (тип времи измерения не используется);

Удобные подручные средства при использовании программы - открытие портов в локальном Windows fw, проверка доступности удаленного сервера (ping) и порта (tnc);

При запуске сервера сообщается порт (которые можно изменить) и полное FQDN текущего сервера. Проверка статуса сервера производится по средствам отслеживания службы.

![Image alt](https://github.com/Lifailon/iperf-gui/blob/rsa/Interface.jpg)

По вопросам и предложениям в Telegram @kup57

