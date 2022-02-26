## FreeRTOS + libopencm3 template makefile project for stm32, stm32f4, stm32f1 and other hardware

rules.mk and Makefile example are taken from this repo:

https://github.com/libopencm3/libopencm3-template.git

### Building:

- to pull git submodules and build libopencm3:

```sh
make build-sub
```

- to refresh submodules and rebuild libopencm3:

```sh
make rebuild-sub
```

libopencm3 needs **python3** to be builded

set DEVICE variable in Makefile to define target device

```sh
DEVICE = stm32f429zi
```
