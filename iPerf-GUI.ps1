#region Форма
Add-Type -assembly System.Windows.Forms
$conf = "C:\Program Files\iPerf GUI\server-list.conf"
$font_conf = "C:\Program Files\iPerf GUI\images\font.conf"
$fon = Get-Content $font_conf
$Font = $fon[0]
$Size = $fon[1]
$iperf = "C:\Program Files\iPerf GUI\iperf\iperf3.exe"
$ico = "C:\Program Files\iPerf GUI\images\ipg.ico"
Add-Type -Assembly System.Drawing # сборка для картинок
$image_start = [System.Drawing.Image]::FromFile("C:\Program Files\iPerf GUI\images\start32px.ico")
$image_stop = [System.Drawing.Image]::FromFile("C:\Program Files\iPerf GUI\images\stop32px.ico")

# функция списка серверов
Function get-srv {
$global:srv = Get-Content $conf # перезаписывает переменную из файла
foreach ($tmp in $srv) {$ComboBox_1.Items.Add($tmp)} # заполняет box
}

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = "Internet Performance Graphical User Interface"
$main_form.Icon = New-Object System.Drawing.Icon($ico)
$main_form.Font = "$Font,$Size"
$main_form.BackColor = "Silver"
$main_form.Size = New-Object System.Drawing.Size(1700,965) 
$main_form.AutoSize = $true

# Вкладки
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Location  = New-Object System.Drawing.Point(10,10)
$TabControl.Size = New-Object System.Drawing.Size(1660,860)
$TabControl.AutoSize = $true
#endregion

#region Клиентская часть iperf
$TabPage_iperf = New-Object System.Windows.Forms.TabPage
$TabPage_iperf.Text = "Internet Performance"
$TabControl.Controls.Add($TabPage_iperf)

# Динамический список
$Label_1 = New-Object System.Windows.Forms.Label
$Label_1.Text = "Выберите сервер:"
$Label_1.Location = New-Object System.Drawing.Point(18,10)
$Label_1.AutoSize = $true
$TabPage_iperf.Controls.Add($Label_1)

$ComboBox_1 = New-Object System.Windows.Forms.ComboBox
$ComboBox_1.Location = New-Object System.Drawing.Point(20,30)
$ComboBox_1.Width = 150
get-srv
$ComboBox_1.Text = $srv[-1] # отображать последний добавленный сервер в список
$TabPage_iperf.Controls.Add($ComboBox_1)

$button_1 = New-Object System.Windows.Forms.Button
$button_1.Text = "Добавить"
$button_1.Font = "$Font,12"
$button_1.Location = New-Object System.Drawing.Point(20,60)
$button_1.Size = New-Object System.Drawing.Size(150,40)
$TabPage_iperf.Controls.Add($button_1)

$button_1.Add_Click({
foreach ($temp in $srv) {$ComboBox_1.Items.Remove($temp)} # очищает box
$ComboBox_1.text >> $conf # добавляет введенный тест в конфигурационный файл
get-srv
})

$button_2 = New-Object System.Windows.Forms.Button
$button_2.Text = "Удалить"
$button_2.Font = "$Font,12"
$button_2.Location = New-Object System.Drawing.Point(20,105)
$button_2.Size = New-Object System.Drawing.Size(150,40)
$TabPage_iperf.Controls.Add($button_2)

$button_2.Add_Click({
$del = $ComboBox_1.text # переменная введенного/выбранного текста в box
foreach ($temp in $srv) {$ComboBox_1.Items.Remove($temp)} # предварительно очищает форму
$srv_1 = $srv -replace "\b$del\b" # находит и удаляет текст в переменной $srv
$srv_2 = $srv_1[0..100] -gt 0 # перезаписывает переменную для удления пустых строк
$srv_2 > $conf # перезаписывает конфигурационный файл
get-srv
})

# Порт
$Label_2 = New-Object System.Windows.Forms.Label
$Label_2.Text = "Порт подключения:"
$Label_2.Location = New-Object System.Drawing.Point(18,155)
$Label_2.AutoSize = $true
$TabPage_iperf.Controls.Add($Label_2)

$TextBox_1 = New-Object System.Windows.Forms.TextBox
$TextBox_1.Location = New-Object System.Drawing.Point(20,175)
$TextBox_1.Size = New-Object System.Drawing.Size(150)
$TextBox_1.Text = "5201"
$TabPage_iperf.Controls.Add($TextBox_1)

$button_3 = New-Object System.Windows.Forms.Button
$button_3.Text = "Проверить"
$button_3.Font = "$Font,12"
$button_3.Location = New-Object System.Drawing.Point(20,205)
$button_3.Size = New-Object System.Drawing.Size(150,40)
$TabPage_iperf.Controls.Add($button_3)

$button_3.Add_Click({
$server = $ComboBox_1.Text
$port = $TextBox_1.Text
$ping = Test-Connection $server -Count 1
if ($ping -ne $null) {$outputBox_2.ForeColor = "green"; $ping_out = @("Сервер $server доступен")}
if ($ping -eq $null) {$outputBox_2.ForeColor = "red"; $ping_out = @("Сервер $server недоступен")}
$outputBox_2.text = $ping_out | out-string
$ping = tnc $server -Port $port -InformationLevel Quiet
if ($ping -eq $true) {$outputBox_2.ForeColor = "green"; $ping_out += @("Порт $port открыт")}
if ($ping -eq $false) {$outputBox_2.ForeColor = "red"; $ping_out += @("Порт $port закрыт")}
$outputBox_2.text = $ping_out | out-string
})

# Потоки
$Label_3 = New-Object System.Windows.Forms.Label
$Label_3.Text = "Количество потоков:"
$Label_3.Location = New-Object System.Drawing.Point(18,255)
$Label_3.AutoSize = $true
$TabPage_iperf.Controls.Add($Label_3)

$NumericUpDown = New-Object System.Windows.Forms.NumericUpDown
$NumericUpDown.Location = New-Object System.Drawing.Point(20,275)
$NumericUpDown.Size = New-Object System.Drawing.Size(150)
$NumericUpDown.text = 1
$TabPage_iperf.Controls.add($NumericUpDown)

# Трафик
$Label_4 = New-Object System.Windows.Forms.Label
$Label_4.Text = "Количество трафика:"
$Label_4.Location = New-Object System.Drawing.Point(18,305)
$Label_4.AutoSize = $true
$TabPage_iperf.Controls.Add($Label_4)

$ComboBox_3 = New-Object System.Windows.Forms.ComboBox
$ComboBox_3.Location = New-Object System.Drawing.Point(20,325)
$ComboBox_3.Size = New-Object System.Drawing.Size(150)
$traffic = @("2Gb","3Gb","4Gb","5Gb","10Gb")
foreach ($numtemp in $traffic) {$ComboBox_3.Items.Add($numtemp)}
$ComboBox_3.Text = "1Gb"
$TabPage_iperf.Controls.Add($ComboBox_3)

# Тип
$Label_5 = New-Object System.Windows.Forms.Label
$Label_5.Text = "Тип проверки:"
$Label_5.Location = New-Object System.Drawing.Point(18,355)
$Label_5.AutoSize = $true
$TabPage_iperf.Controls.Add($Label_5)

$RadioButton_1 = New-Object System.Windows.Forms.RadioButton
$RadioButton_1.AutoSize = $true
$RadioButton_1.Text = "Отдача"
$RadioButton_1.Location = New-Object System.Drawing.Point(20,375)
$TabPage_iperf.Controls.Add($RadioButton_1)

$RadioButton_2 = New-Object System.Windows.Forms.RadioButton
$RadioButton_2.AutoSize = $true
$RadioButton_2.Text = "Загрузка"
$RadioButton_2.Checked = $true
$RadioButton_2.Location = New-Object System.Drawing.Point(20,395)
$TabPage_iperf.Controls.Add($RadioButton_2)

# Подключение
$button_4 = New-Object System.Windows.Forms.Button
$button_4.Text = "Подключиться"
$button_4.Font = "$Font,14"
$button_4.Location = New-Object System.Drawing.Point(20,425)
$button_4.Size = New-Object System.Drawing.Size(150,60)
$TabPage_iperf.Controls.Add($button_4)

function parsing {
$out = $out -replace "Reverse.+"
$out = $out -replace "Connecting.+"
$out = $out -replace "iperf Done."
$out = $out -replace "- - - .+","Результат:"
$out = $out -replace "local","Откуда:"
$out = $out -replace "port","порт"
$out = $out -replace "connected to","Куда:"
$out = $out -replace "Interval","Время работы"
$out = $out -replace "Transfer","Передано"
$out = $out -replace "Bandwidth","Скорость"
$out = $out -replace "sender","Отправитель"
$out = $out -replace "receiver","Получатель"
$out = $out -replace "\bMbits/sec\b","Мбит в секунду"
$out = $out -replace "\bsec\b","секунд"
$out = $out -replace "\bMBytes\b","Мбайт"
$out = $out -replace "\[.{1,3}\]\s{1,3}"
$global:out = $out -replace "GBytes","Гбайт" # передать в глобальную переменную
}

$button_4.Add_Click({
$outputBox_2.ForeColor = "black" # вернуть цвет букв вывода
$ProgressBar_1.Value = 10 # запустить прогресс
$server = $ComboBox_1.Text
$port = $TextBox_1.Text
$stream = $NumericUpDown.Text
$traf = $ComboBox_3.Text
$log = "C:\Program Files\iPerf GUI\"+"$server"+"-log-temp"+".log" # имя временного лог-файла
$global:start_time = (Get-Date -Format 'dd/MM/yyyy hh:mm') # текущее время на момент запуска для отчёта

if ($RadioButton_1.Checked -eq $true) {
$outputBox_2.text = "Передача $traf трафика на сервер: $server"
$ProgressBar_1.Value = 10
Start-Sleep -Seconds 1 # пауза для имитации статуса прогресса (debug)
$ProgressBar_1.Value = 30
.$iperf -c $server -p $port -P $stream -n $traf --logfile $log # точка в начале для запуска исполняемого файла
$ProgressBar_1.Value = 50
Start-Sleep -Seconds 1
$ProgressBar_1.Value = 70
$global:out = Get-Content $log # читать из лог файла и передать в глобальную переменную для функции
parsing # выполнить функцию парсинга вывода (русификация)
rm $log # удалить лог-файл
Start-Sleep -Seconds 1
$ProgressBar_1.Value = 100
$outputBox_2.text += $out | out-string
}

if ($RadioButton_2.Checked -eq $true) {
$outputBox_2.text = "Скачивание $traf трафика с сервера: $server"
$ProgressBar_1.Value = 10
Start-Sleep -Seconds 1
$ProgressBar_1.Value = 30
.$iperf -R -c $server -p $port -P $stream -n $traf --logfile $log
$ProgressBar_1.Value = 50
Start-Sleep -Seconds 1
$ProgressBar_1.Value = 70
$global:out = Get-Content $log
parsing
rm $log
Start-Sleep -Seconds 1
$ProgressBar_1.Value = 100
$outputBox_2.text += $out | out-string
}
})

# Разделитель по вертикали
$outputBox_1 = New-Object System.Windows.Forms.TextBox
$outputBox_1.Location = New-Object System.Drawing.Point(200,0)
$outputBox_1.Size = New-Object System.Drawing.Size(1,830)
$outputBox_1.BackColor = "Black"
$outputBox_1.MultiLine = $True
$TabPage_iperf.Controls.Add($outputBox_1)

# Вывод
$outputBox_2 = New-Object System.Windows.Forms.TextBox
$outputBox_2.Location = New-Object System.Drawing.Point(230,30)
$outputBox_2.Size = New-Object System.Drawing.Size(1400,750)
$outputBox_2.Font = "$Font,14"
$outputBox_2.MultiLine = $True
$TabPage_iperf.Controls.Add($outputBox_2)

# Скролл по вертикали (HScrollBar по горизантали)
$VScrollBar = New-Object System.Windows.Forms.VScrollBar
$VScrollBar.Size = New-Object System.Drawing.Size(16,176)
$VScrollBar.Location  = New-Object System.Drawing.Point(380,0)
$outputBox_2.Scrollbars = "Vertical"

# Прогресс
$ProgressBar_1 = New-Object System.Windows.Forms.ProgressBar
$ProgressBar_1.Location  = New-Object System.Drawing.Point(20,490)
$ProgressBar_1.Size = New-Object System.Drawing.Size(150,25)
$ProgressBar_1.Value = 0
$TabPage_iperf.Controls.add($ProgressBar_1)

# Сохранить
$button_5 = New-Object System.Windows.Forms.Button
$button_5.Text = "Сохранить"
$button_5.Font = "$Font,12"
$button_5.Location = New-Object System.Drawing.Point(20,520)
$button_5.Size = New-Object System.Drawing.Size(150,40)
$TabPage_iperf.Controls.Add($button_5)

$button_5.Add_Click({
$SaveFile = New-Object System.Windows.Forms.SaveFileDialog
$SaveFile.filter = "текст (*.txt)| *.txt"
$SaveFile.ShowDialog() | Out-Null
$SaveDir = @($SaveFile.FileNames)
$out[0] = "Время запуска проверки: $start_time"
$out | Out-File "$SaveDir"
})

# Разделитель по горизонтали
$outputBox_3 = New-Object System.Windows.Forms.TextBox
$outputBox_3.Location = New-Object System.Drawing.Point(0,575)
$outputBox_3.Size = New-Object System.Drawing.Size(200,1)
$outputBox_3.BackColor = "Black"
$outputBox_3.MultiLine = $True
$TabPage_iperf.Controls.Add($outputBox_3)
#endregion

#region Серверная часть iperf
$Label_6 = New-Object System.Windows.Forms.Label
$Label_6.Text = "Сервер"
$Label_6.Font = "$Font,14"
$Label_6.Location = New-Object System.Drawing.Point(18,585)
$Label_6.AutoSize = $true
$TabPage_iperf.Controls.Add($Label_6)

$Label_7 = New-Object System.Windows.Forms.Label
$Label_7.Text = "Порт сервера:"
$Label_7.Location = New-Object System.Drawing.Point(18,615)
$Label_7.AutoSize = $true
$TabPage_iperf.Controls.Add($Label_7)

$TextBox_2 = New-Object System.Windows.Forms.TextBox
$TextBox_2.Location = New-Object System.Drawing.Point(20,635)
$TextBox_2.Size = New-Object System.Drawing.Size(150)
$TextBox_2.AutoSize
$TextBox_2.Text = "5201"
$TabPage_iperf.Controls.Add($TextBox_2)

# Firewall
$button_6 = New-Object System.Windows.Forms.Button
$button_6.Text = "Открыть"
$button_6.Font = "$Font,12"
$button_6.Location = New-Object System.Drawing.Point(20,665)
$button_6.Size = New-Object System.Drawing.Size(150,40)
$TabPage_iperf.Controls.Add($button_6)

$button_6.Add_Click({
$port_server = $TextBox_2.Text
$fw_name = "$port_server"+" Open Port Server iPerf GUI"
New-NetFirewallRule -DisplayName "$fw_name" -Profile @("Domain","Private","Public") -Direction Inbound -Action Allow -Protocol TCP -LocalPort @("$port_server")
$fw_out = Get-NetFirewallRule -DisplayName $fw_name
$fw_out2 = @("Создано правило в Firewall: "+$fw_out.DisplayName)
$fw_out2 += "Статус: "+$fw_out.PrimaryStatus
$outputBox_2.ForeColor = "black"
$outputBox_2.text = $fw_out2 | out-string
})

$button_start = New-Object System.Windows.Forms.Button
$button_start.Text = "    Запустить"
$button_start.Font = "$Font,12"
$button_start.Image = $image_start
$button_start.ImageAlign = "MiddleLeft" # расположение изображения слева
$button_start.Location = New-Object System.Drawing.Point(20,715)
$button_start.Size = New-Object System.Drawing.Size(150,40)
$TabPage_iperf.Controls.Add($button_start)

$button_start.Add_Click({
$port_server = $TextBox_2.Text
Start-Process -FilePath "$iperf" -ArgumentList "-s -D -p $port_server"
$hostname = "$env:computername"+"."+"$env:USERDNSDOMAIN"
$outputBox_2.text = @("Сервер запущен на порту: $port_server","Имя сервера: $hostname") | out-string
$Status.Text = "Сервер запущен"
})

$button_stop = New-Object System.Windows.Forms.Button
$button_stop.Text = "       Остановить"
$button_stop.Font = "$Font,12"
$button_stop.Image = $image_stop
$button_stop.ImageAlign = "MiddleLeft"
$button_stop.Location = New-Object System.Drawing.Point(20,765)
$button_stop.Size = New-Object System.Drawing.Size(150,40)
$TabPage_iperf.Controls.Add($button_stop)

$button_stop.Add_Click({
$wshell = New-Object -ComObject Wscript.Shell
$proc = Get-Process | Where ProcessName -match "iperf3" | select ProcessName,StartTime
$status_proc = $proc.ProcessName
if ($status_proc.count -gt 0) {
$server_start = $proc.StartTime
$Output = $wshell.Popup("Сервер запущен в $server_start, остановить сервер?",0,"Статус сервера",4)
if ($output -eq "6") {Get-Process | Where ProcessName -match "iperf3" | Stop-Process}
} else {
$Output = $wshell.Popup("Сервер не запущен",0,"Статус сервера",64)
}
# Повторная проверка статуса
$proc = Get-Process | Where ProcessName -match "iperf3" | select ProcessName,StartTime
$status_proc = $proc.ProcessName
if ($status_proc.count -gt 0) {$Status.Text = "Сервер запущен"}
if ($status_proc.count -eq 0) {$Status.Text = "Сервер остановлен"}
})
#endregion

#region Меню и статус
$Menu = New-Object System.Windows.Forms.MainMenu
$main_form.Menu = $Menu

$menuItem_file = New-Object System.Windows.Forms.menuItem # создать вкладку
$menuItem_file.Text = "Файл"
$Menu.MenuItems.Add($menuItem_file) # добавить в меню

$menuItem_file_exit = New-Object System.Windows.Forms.menuItem # создать кнопку
$menuItem_file_exit.Text = "Выход"
$menuItem_file_exit.Add_Click({$main_form.Close()})
$menuItem_file.MenuItems.Add($menuItem_file_exit) # добавить кнопку

$StatusStrip = New-Object System.Windows.Forms.StatusStrip # создать статус
$StatusStrip.BackColor = "white" # цвет фона
$main_form.Controls.Add($statusStrip) # добавить полосу статуса

$Status = New-Object System.Windows.Forms.ToolStripMenuItem
$StatusStrip.Items.Add($Status) # добавить событие
$Status.Text = "©Telegram @kup57"
#endregion

$main_form.Controls.add($TabControl)
$main_form.ShowDialog()