#![no_main]
#![no_std]

mod pins;

use ariel_os::{
    gpio::{Input, Pull},
    log::info,
};

#[ariel_os::task(autostart, peripherals)]
async fn main(peripherals: pins::Peripherals) {
    info!(
        "Started blazing-fan, running on a {} board.",
        ariel_os::buildinfo::BOARD
    );

    let mut button = Input::builder(peripherals.btn, Pull::Up)
        .build_with_interrupt()
        .expect("button should be present");

    loop {
        button.wait_for_any_edge().await;
        info!("Button state: {}", button.is_low());
    }
}
