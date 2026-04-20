#![no_main]
#![no_std]

mod pins;

use ariel_os::{
    gpio::{Input, Pull},
    hal,
    log::{error, info},
};

use crate::pins::{ButtonPeripherals, UartAPeripherals, UartBPeripherals};

use embedded_io_async::{Read as _, Write as _};

#[ariel_os::task(autostart, peripherals)]
async fn button_listener(peripherals: ButtonPeripherals) {
    let mut button = Input::builder(peripherals.button, Pull::Up)
        .build_with_interrupt()
        .expect("BUTTON on PIN_12 should be present");

    loop {
        button.wait_for_any_edge().await;
        info!("Button state: {}", button.is_low());
    }
}

#[ariel_os::task(autostart, peripherals)]
async fn uart_a_listener(peripherals: UartAPeripherals) {
    let uart_0_config = hal::uart::Config::default();
    let mut uart_0_rx_buf = [0u8; 32];
    let mut uart_0_tx_buf = [0u8; 32];
    let mut uart_a = pins::UartA::new(
        peripherals.uart0_rx,
        peripherals.uart0_tx,
        &mut uart_0_rx_buf,
        &mut uart_0_tx_buf,
        uart_0_config,
    )
    .expect("UART0 should be present");

    loop {
        let mut buf = [0u8; 2];
        if let Ok(()) = uart_a.read_exact(&mut buf).await {
            info!("bytes from uart_a");
        } else {
            error!("failed to read from uart_a");
        }
    }
}

#[ariel_os::task(autostart, peripherals)]
async fn uart_b_listener(peripherals: UartBPeripherals) {
    let uart_1_config = hal::uart::Config::default();
    let mut uart_1_rx_buf = [0u8; 32];
    let mut uart_1_tx_buf = [0u8; 32];
    let mut _uart_a = pins::UartB::new(
        peripherals.uart1_rx,
        peripherals.uart1_tx,
        &mut uart_1_rx_buf,
        &mut uart_1_tx_buf,
        uart_1_config,
    )
    .expect("UART1 should be present");
}
