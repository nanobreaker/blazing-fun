use ariel_os::hal::peripherals;

#[cfg(context = "rp2040")]
ariel_os::hal::define_peripherals!(Peripherals { btn: PIN_12 });
