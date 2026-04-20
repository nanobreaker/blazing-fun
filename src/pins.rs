use ariel_os::hal::{peripherals, uart};

#[cfg(context = "rp2040")]
pub type UartA<'a> = uart::UART0<'a>;

#[cfg(context = "rp2040")]
pub type UartB<'a> = uart::UART1<'a>;

#[cfg(context = "rp2040")]
ariel_os::hal::define_peripherals!(ButtonPeripherals { button: PIN_12 });

#[cfg(context = "rp2040")]
ariel_os::hal::define_peripherals!(UartAPeripherals {
    uart0_tx: PIN_0,
    uart0_rx: PIN_1,
});

#[cfg(context = "rp2040")]
ariel_os::hal::define_peripherals!(UartBPeripherals {
    uart1_tx: PIN_8,
    uart1_rx: PIN_9
});
