EESchema Schematic File Version 4
LIBS:RTC8088-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Real Time Clock for PCXT"
Date ""
Rev "2.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L RTC8088-rescue:ATF16V8B-my_components U2
U 1 1 5DF7CA54
P 9650 3350
F 0 "U2" H 9650 4138 60  0000 C CNN
F 1 "ATF16V8B" H 9650 4032 60  0000 C CNN
F 2 "SergeyLibraries:IC_DIP20_300" H 9650 3250 60  0001 C CNN
F 3 "" H 9650 3250 60  0000 C CNN
	1    9650 3350
	1    0    0    -1  
$EndComp
$Comp
L RTC8088-rescue:BUSPC_DEV-my_components BUS1
U 1 1 5DF83AF6
P 2300 3900
F 0 "BUS1" H 2300 5710 70  0000 C CNN
F 1 "ISA 8 BITS" H 2300 5589 70  0000 C CNN
F 2 "SergeyLibraries:BUS_RTC8088" H 2300 3900 60  0001 C CNN
F 3 "" H 2300 3900 60  0000 C CNN
	1    2300 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3100 5400 3650 5400
Wire Wire Line
	3100 5200 3650 5200
Wire Wire Line
	3100 5100 3650 5100
Wire Wire Line
	3100 5000 3650 5000
Wire Wire Line
	3100 4900 3650 4900
Wire Wire Line
	3100 4800 3650 4800
Wire Wire Line
	3100 4700 3650 4700
Wire Wire Line
	3100 4600 3650 4600
Wire Wire Line
	3100 4500 3650 4500
Wire Wire Line
	9150 2900 8700 2900
Wire Wire Line
	9150 3000 8700 3000
Wire Wire Line
	9150 3100 8700 3100
Wire Wire Line
	9150 3200 8700 3200
Wire Wire Line
	9150 3300 8700 3300
Wire Wire Line
	9150 3400 8700 3400
Wire Wire Line
	9150 3500 8700 3500
Wire Wire Line
	9150 3600 8700 3600
Wire Wire Line
	9150 3700 8700 3700
Wire Wire Line
	10150 3000 10600 3000
Wire Wire Line
	9150 3800 8700 3800
Wire Wire Line
	10150 3400 10600 3400
Wire Wire Line
	10150 3500 10600 3500
Wire Wire Line
	6450 3400 6850 3400
Wire Wire Line
	3100 3200 3650 3200
Wire Wire Line
	3100 3100 3650 3100
Wire Wire Line
	3100 3000 3650 3000
Wire Wire Line
	3100 2900 3650 2900
Wire Wire Line
	3100 2800 3650 2800
Wire Wire Line
	3100 2700 3650 2700
Wire Wire Line
	3100 2600 3650 2600
Wire Wire Line
	3100 2500 3650 2500
Wire Wire Line
	5050 3100 4650 3100
Wire Wire Line
	5050 3200 4650 3200
Wire Wire Line
	5050 3300 4650 3300
Wire Wire Line
	5050 3400 4650 3400
Wire Wire Line
	5050 3500 4650 3500
Wire Wire Line
	5050 3600 4650 3600
Wire Wire Line
	5050 3700 4650 3700
Wire Wire Line
	5050 3800 4650 3800
Wire Wire Line
	5050 4000 4650 4000
Wire Wire Line
	5050 4100 4650 4100
Wire Wire Line
	5050 4200 4650 4200
Wire Wire Line
	5050 4300 4650 4300
$Comp
L RTC8088-rescue:Crystal-Device X1
U 1 1 5DC959D0
P 7050 2950
F 0 "X1" V 7096 2819 50  0000 R CNN
F 1 "32768Hz" V 7005 2819 50  0000 R CNN
F 2 "SergeyLibraries:Crystal_32K_Vert" H 7050 2950 50  0001 C CNN
F 3 "~" H 7050 2950 50  0001 C CNN
	1    7050 2950
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6450 2900 6750 2900
Wire Wire Line
	6750 2900 6750 2800
Wire Wire Line
	6750 2800 7050 2800
Wire Wire Line
	6450 3000 6750 3000
Wire Wire Line
	6750 3000 6750 3100
Wire Wire Line
	6750 3100 7050 3100
$Comp
L RTC8088-rescue:GND-power #PWR0101
U 1 1 5DC997E9
P 4650 4450
F 0 "#PWR0101" H 4650 4200 50  0001 C CNN
F 1 "GND" H 4655 4277 50  0000 C CNN
F 2 "" H 4650 4450 50  0001 C CNN
F 3 "" H 4650 4450 50  0001 C CNN
	1    4650 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 4300 4650 4450
$Comp
L RTC8088-rescue:+5V-power #PWR0102
U 1 1 5DC9B343
P 4950 2750
F 0 "#PWR0102" H 4950 2600 50  0001 C CNN
F 1 "+5V" H 4965 2923 50  0000 C CNN
F 2 "" H 4950 2750 50  0001 C CNN
F 3 "" H 4950 2750 50  0001 C CNN
	1    4950 2750
	1    0    0    -1  
$EndComp
$Comp
L RTC8088-rescue:Jumper-Device J1
U 1 1 5DC9D93E
P 7500 4300
F 0 "J1" V 7454 4427 50  0000 L CNN
F 1 "CMOS CLEAR" V 7545 4427 50  0000 L CNN
F 2 "SergeyLibraries:Conn_Pin_Header_2x1_2.54mm_NoKey" H 7500 4300 50  0001 C CNN
F 3 "~" H 7500 4300 50  0001 C CNN
	1    7500 4300
	0    1    1    0   
$EndComp
$Comp
L RTC8088-rescue:GND-power #PWR0103
U 1 1 5DC9F42F
P 7500 4900
F 0 "#PWR0103" H 7500 4650 50  0001 C CNN
F 1 "GND" H 7505 4727 50  0000 C CNN
F 2 "" H 7500 4900 50  0001 C CNN
F 3 "" H 7500 4900 50  0001 C CNN
	1    7500 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 4900 7500 4600
Wire Wire Line
	7500 4000 7500 3800
$Comp
L RTC8088-rescue:GND-power #PWR0104
U 1 1 5DCA295F
P 5650 4950
F 0 "#PWR0104" H 5650 4700 50  0001 C CNN
F 1 "GND" H 5655 4777 50  0000 C CNN
F 2 "" H 5650 4950 50  0001 C CNN
F 3 "" H 5650 4950 50  0001 C CNN
	1    5650 4950
	1    0    0    -1  
$EndComp
$Comp
L RTC8088-rescue:GND-power #PWR0105
U 1 1 5DCA2CBC
P 5850 4950
F 0 "#PWR0105" H 5850 4700 50  0001 C CNN
F 1 "GND" H 5855 4777 50  0000 C CNN
F 2 "" H 5850 4950 50  0001 C CNN
F 3 "" H 5850 4950 50  0001 C CNN
	1    5850 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4400 5650 4950
Wire Wire Line
	5850 4400 5850 4950
$Comp
L RTC8088-rescue:+5V-power #PWR0106
U 1 1 5DCA6509
P 5750 2250
F 0 "#PWR0106" H 5750 2100 50  0001 C CNN
F 1 "+5V" H 5765 2423 50  0000 C CNN
F 2 "" H 5750 2250 50  0001 C CNN
F 3 "" H 5750 2250 50  0001 C CNN
	1    5750 2250
	1    0    0    -1  
$EndComp
$Comp
L RTC8088-rescue:DS12885-my_components U1
U 1 1 5DF7ACB7
P 5750 3550
F 0 "U1" H 5750 4538 60  0000 C CNN
F 1 "DS12885" H 5750 4432 60  0000 C CNN
F 2 "SergeyLibraries:IC_DIP24_600" H 5750 3550 60  0001 C CNN
F 3 "" H 5750 3550 60  0000 C CNN
	1    5750 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5050 2900 4950 2900
Wire Wire Line
	4950 2900 4950 2750
$Comp
L RTC8088-rescue:Battery_Cell-Device CR2032
U 1 1 5DCAB0F6
P 6950 4350
F 0 "CR2032" H 7068 4446 50  0000 L CNN
F 1 "3V" H 7068 4355 50  0000 L CNN
F 2 "SergeyLibraries:Battery_Holder_CR2032_Mouser_122-2520-GR" V 6950 4410 50  0001 C CNN
F 3 "~" V 6950 4410 50  0001 C CNN
	1    6950 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	6450 4000 6650 4000
Wire Wire Line
	6950 4000 6950 4150
$Comp
L RTC8088-rescue:GND-power #PWR0107
U 1 1 5DCADE44
P 6950 4900
F 0 "#PWR0107" H 6950 4650 50  0001 C CNN
F 1 "GND" H 6955 4727 50  0000 C CNN
F 2 "" H 6950 4900 50  0001 C CNN
F 3 "" H 6950 4900 50  0001 C CNN
	1    6950 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6950 4900 6950 4450
Wire Wire Line
	1500 2700 1000 2700
Wire Wire Line
	1500 4800 1000 4800
Wire Wire Line
	1500 4700 1000 4700
Wire Wire Line
	1500 4600 1000 4600
Wire Wire Line
	1500 4500 1000 4500
Wire Wire Line
	1500 4400 1000 4400
$Comp
L RTC8088-rescue:GND-power #PWR0108
U 1 1 5DD32DE6
P 9650 4250
F 0 "#PWR0108" H 9650 4000 50  0001 C CNN
F 1 "GND" H 9655 4077 50  0000 C CNN
F 2 "" H 9650 4250 50  0001 C CNN
F 3 "" H 9650 4250 50  0001 C CNN
	1    9650 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	9650 4250 9650 3900
$Comp
L RTC8088-rescue:+5V-power #PWR0109
U 1 1 5DD36465
P 9650 2250
F 0 "#PWR0109" H 9650 2100 50  0001 C CNN
F 1 "+5V" H 9665 2423 50  0000 C CNN
F 2 "" H 9650 2250 50  0001 C CNN
F 3 "" H 9650 2250 50  0001 C CNN
	1    9650 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	9650 2800 9650 2250
Wire Wire Line
	6450 3800 7500 3800
Wire Wire Line
	5750 2250 5750 2800
$Comp
L RTC8088-rescue:GND-power #PWR0110
U 1 1 5DC819C0
P 1250 5550
F 0 "#PWR0110" H 1250 5300 50  0001 C CNN
F 1 "GND" H 1255 5377 50  0000 C CNN
F 2 "" H 1250 5550 50  0001 C CNN
F 3 "" H 1250 5550 50  0001 C CNN
	1    1250 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 5550 1250 5400
Wire Wire Line
	1250 5400 1500 5400
$Comp
L RTC8088-rescue:GND-power #PWR0111
U 1 1 5DC854DA
P 1300 2200
F 0 "#PWR0111" H 1300 1950 50  0001 C CNN
F 1 "GND" H 1305 2027 50  0000 C CNN
F 2 "" H 1300 2200 50  0001 C CNN
F 3 "" H 1300 2200 50  0001 C CNN
	1    1300 2200
	-1   0    0    1   
$EndComp
Wire Wire Line
	1300 2200 1300 2400
Wire Wire Line
	1300 2400 1500 2400
$Comp
L RTC8088-rescue:+5V-power #PWR0112
U 1 1 5DC89AAF
P 1000 2200
F 0 "#PWR0112" H 1000 2050 50  0001 C CNN
F 1 "+5V" H 1015 2373 50  0000 C CNN
F 2 "" H 1000 2200 50  0001 C CNN
F 3 "" H 1000 2200 50  0001 C CNN
	1    1000 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 2600 1500 2600
Wire Wire Line
	1000 2600 1000 2200
Wire Wire Line
	1500 3300 1300 3300
Wire Wire Line
	1300 3300 1300 2400
Connection ~ 1300 2400
Wire Wire Line
	10150 3300 10600 3300
Wire Wire Line
	10150 3200 10600 3200
Wire Wire Line
	10150 3100 10600 3100
Wire Wire Line
	3100 3400 3650 3400
Wire Wire Line
	1500 3700 1000 3700
Wire Wire Line
	1500 3600 1000 3600
Wire Wire Line
	10150 3600 10600 3600
NoConn ~ 3100 2400
NoConn ~ 3100 3300
NoConn ~ 3100 3500
NoConn ~ 3100 3600
NoConn ~ 3100 3700
NoConn ~ 3100 3800
NoConn ~ 3100 3900
NoConn ~ 3100 4000
NoConn ~ 3100 4100
NoConn ~ 3100 4200
NoConn ~ 3100 4300
NoConn ~ 3100 4400
NoConn ~ 3100 5300
NoConn ~ 1500 4900
NoConn ~ 1500 5000
NoConn ~ 1500 5100
NoConn ~ 1500 5200
NoConn ~ 1500 5300
NoConn ~ 1500 4300
NoConn ~ 1500 4200
NoConn ~ 1500 4100
NoConn ~ 1500 4000
NoConn ~ 1500 3900
NoConn ~ 1500 3800
NoConn ~ 1500 3500
NoConn ~ 1500 3400
NoConn ~ 1500 3200
NoConn ~ 1500 3100
NoConn ~ 1500 3000
NoConn ~ 1500 2900
NoConn ~ 1500 2800
NoConn ~ 1500 2500
NoConn ~ 6450 3200
NoConn ~ 6450 3600
NoConn ~ 6450 4200
NoConn ~ 10150 2900
Text Label 1000 2700 0    50   ~ 0
IRQ9
Text Label 1000 3600 0    50   ~ 0
IOW
Text Label 1000 3700 0    50   ~ 0
IOR
Text Label 1000 4400 0    50   ~ 0
IRQ7
Text Label 1000 4500 0    50   ~ 0
IRQ6
Text Label 1000 4600 0    50   ~ 0
IRQ5
Text Label 1000 4700 0    50   ~ 0
IRQ4
Text Label 1000 4800 0    50   ~ 0
IRQ3
Text Label 3650 4500 2    50   ~ 0
A9
Text Label 3650 4600 2    50   ~ 0
A8
Text Label 3650 4700 2    50   ~ 0
A7
Text Label 3650 4800 2    50   ~ 0
A6
Text Label 3650 4900 2    50   ~ 0
A5
Text Label 3650 5000 2    50   ~ 0
A4
Text Label 3650 5100 2    50   ~ 0
A3
Text Label 3650 5200 2    50   ~ 0
A2
Text Label 3650 3400 2    50   ~ 0
AEN
Text Label 3650 2500 2    50   ~ 0
D7
Text Label 3650 2600 2    50   ~ 0
D6
Text Label 3650 2700 2    50   ~ 0
D5
Text Label 3650 2800 2    50   ~ 0
D4
Text Label 3650 2900 2    50   ~ 0
D3
Text Label 3650 3000 2    50   ~ 0
D2
Text Label 3650 3100 2    50   ~ 0
D1
Text Label 3650 3200 2    50   ~ 0
D0
Text Label 3650 5400 2    50   ~ 0
A0
Text Label 6850 3400 2    50   ~ 0
IRQ
Text Label 4650 3100 0    50   ~ 0
D0
Text Label 4650 3200 0    50   ~ 0
D1
Text Label 4650 3300 0    50   ~ 0
D2
Text Label 4650 3400 0    50   ~ 0
D3
Text Label 4650 3500 0    50   ~ 0
D4
Text Label 4650 3600 0    50   ~ 0
D5
Text Label 4650 3700 0    50   ~ 0
D6
Text Label 4650 3800 0    50   ~ 0
D7
Text Label 4650 4000 0    50   ~ 0
RTCALE
Text Label 4650 4100 0    50   ~ 0
RTCRD
Text Label 4650 4200 0    50   ~ 0
RTCWR
Text Label 8700 2900 0    50   ~ 0
A0
Text Label 8700 3000 0    50   ~ 0
A2
Text Label 8700 3100 0    50   ~ 0
A3
Text Label 8700 3200 0    50   ~ 0
A4
Text Label 8700 3300 0    50   ~ 0
A5
Text Label 8700 3400 0    50   ~ 0
A6
Text Label 8700 3500 0    50   ~ 0
A7
Text Label 8700 3600 0    50   ~ 0
A8
Text Label 8700 3700 0    50   ~ 0
A9
Text Label 8700 3800 0    50   ~ 0
IRQ
Text Label 10600 3000 2    50   ~ 0
IRQOUT
Text Label 10600 3100 2    50   ~ 0
AEN
Text Label 10600 3200 2    50   ~ 0
RTCRD
Text Label 10600 3300 2    50   ~ 0
RTCWR
Text Label 10600 3400 2    50   ~ 0
RTCALE
Text Label 10600 3500 2    50   ~ 0
IOR
Text Label 10600 3600 2    50   ~ 0
IOW
$Comp
L RTC8088-rescue:Conn_02x06_Odd_Even-Connector_Generic J2
U 1 1 5DD3559F
P 9550 5300
F 0 "J2" H 9600 5717 50  0000 C CNN
F 1 "IRQ SETUP" H 9600 5626 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x06_P2.54mm_Vertical" H 9550 5300 50  0001 C CNN
F 3 "~" H 9550 5300 50  0001 C CNN
	1    9550 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	9350 5100 9250 5100
Wire Wire Line
	9350 5200 9250 5200
Wire Wire Line
	9250 5200 9250 5100
Connection ~ 9250 5100
Wire Wire Line
	9250 5100 8600 5100
Wire Wire Line
	9350 5300 9250 5300
Wire Wire Line
	9250 5300 9250 5200
Connection ~ 9250 5200
Wire Wire Line
	9350 5400 9250 5400
Wire Wire Line
	9250 5400 9250 5300
Connection ~ 9250 5300
Wire Wire Line
	9350 5500 9250 5500
Wire Wire Line
	9250 5500 9250 5400
Connection ~ 9250 5400
Wire Wire Line
	9350 5600 9250 5600
Wire Wire Line
	9250 5600 9250 5500
Connection ~ 9250 5500
Wire Wire Line
	9850 5100 10500 5100
Wire Wire Line
	9850 5200 10500 5200
Wire Wire Line
	9850 5300 10500 5300
Wire Wire Line
	9850 5400 10500 5400
Wire Wire Line
	9850 5500 10500 5500
Wire Wire Line
	9850 5600 10500 5600
Text Label 8600 5100 0    50   ~ 0
IRQOUT
Text Label 10500 5100 2    50   ~ 0
IRQ9
Text Label 10500 5200 2    50   ~ 0
IRQ7
Text Label 10500 5300 2    50   ~ 0
IRQ6
Text Label 10500 5400 2    50   ~ 0
IRQ5
Text Label 10500 5500 2    50   ~ 0
IRQ4
Text Label 10500 5600 2    50   ~ 0
IRQ3
$Comp
L Diodes:1N4148 D1
U 1 1 5ED17F43
P 6650 4600
F 0 "D1" V 6696 4521 50  0000 R CNN
F 1 "1N4148" V 6605 4521 50  0000 R CNN
F 2 "Diode_THT:D_DO-35_SOD27_P7.62mm_Horizontal" H 6650 4425 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/1N4148_1N4448.pdf" H 6650 4600 50  0001 C CNN
	1    6650 4600
	0    1    1    0   
$EndComp
Wire Wire Line
	6650 4450 6650 4000
Connection ~ 6650 4000
Wire Wire Line
	6650 4000 6950 4000
$Comp
L RTC8088-rescue:GND-power #PWR?
U 1 1 5ED2D423
P 6650 4900
F 0 "#PWR?" H 6650 4650 50  0001 C CNN
F 1 "GND" H 6655 4727 50  0000 C CNN
F 2 "" H 6650 4900 50  0001 C CNN
F 3 "" H 6650 4900 50  0001 C CNN
	1    6650 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6650 4900 6650 4750
$EndSCHEMATC
