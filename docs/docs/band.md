## Status

1. uMyo sensor supports 3 modes right now: RF24, RF52, and BLE Advertising mode. If we want to connect to iOS, BLE Advertising mode limits bandwidth too much. Need to reverse engineer and flash a firmware with BLE GATT capabilities.
2. How to flash-over-the-air quickly
3. If we're not going to be using the other modes, remap one of the button presses to pairing or something

## Development

### Dependencies

The project was setup using platformio, so: 

```
brew install platformio
```

### Quick Start 

IDE: 

```
TODO
```

Vim: 

```
TODO
```

### Flash configs 

## Hardware

### ESP32-C3-MINI Module

#### Naming Schemes

So the model naming scheme is like: ESP32-C3-MINI-{1,1U}-{N4,H4}

- The 1/1U refers to the antenna option:
    - 1: Onboard PCB antenna
    - 1U: External antenna via a connector
- The N4/H4 refers to the chip used:
    - N4: Uses the ESP32-C3FN4 chip
    - H4: Uses the ESP32-C3FH4 chip
- Both of them are exactly the same 32-bit RISC-V single-core processor, except that the H4 supports higher operating temperature than the N4.

#### Pin Definitions

| Name     | No.                                        | Type     | Function                                                                                                 |
| -------- | ------------------------------------------ | -------- | -------------------------------------------------------------------------------------------------------- |
| GND      | 1, 2, 11, 14, 36-53                        | P        | Ground                                                                                                   |
| 3V3      | 3                                          | P        | Power supply                                                                                             |
| NC       | 4, 7, 9, 10, 15, 17, 24, 25, 28, 29, 32-35 | —        | NC                                                                                                       |
| IO2      | 5                                          | I/O/T    | GPIO2, ADC1_CH2, FSPIQ                                                                                   |
| IO3      | 6                                          | I/O/T    | GPIO3, ADC1_CH3                                                                                          |
| EN       | 8                                          | I        | High: on, enables the chip.<br>Low: off, the chip powers off.<br>Note: Do not leave the EN pin floating. |
| IO0      | 12                                         | I/O/T    | GPIO0, ADC1_CH0, XTAL_32K_P                                                                              |
| IO1      | 13                                         | I/O/T    | GPIO1, ADC1_CH1, XTAL_32K_N                                                                              |
| IO10     | 16                                         | I/O/T    | GPIO10, FSPICS0                                                                                          |
| IO4      | 18                                         | I/O/T    | GPIO4, ADC1_CH4, FSPIHD, MTMS                                                                            |
| IO5      | 19                                         | I/O/T    | GPIO5, ADC2_CH0, FSPIWP, MTDI                                                                            |
| IO6      | 20                                         | I/O/T    | GPIO6, FSPICLK, MTCK                                                                                     |
| IO7      | 21                                         | I/O/T    | GPIO7, FSPID, MTDO                                                                                       |
| IO8      | 22                                         | I/O/T    | GPIO8                                                                                                    |
| IO9      | 23                                         | I/O/T    | GPIO9                                                                                                    |
| IO18     | 26                                         | I/O/T    | GPIO18, USB_D-                                                                                           |
| IO19     | 27                                         | I/O/T    | GPIO19, USB_D+                                                                                           |
| RXD0     | 30                                         | I/O/T    | GPIO20, U0RXD                                                                                            |
| TXD0     | 31                                         | I/O/T    | GPIO21, U0TXD                                                                                            |


### ABRobot ESP32-C3-MINI Dev Module 

![](../assets/images/abrobot-esp32-c3-mini.jpeg)

## Resources
