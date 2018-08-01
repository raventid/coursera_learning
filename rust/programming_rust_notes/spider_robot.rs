use std::cell::Cell;


// I think I can think of Cell as getter/setter pair
// You can not get the ref value from Cell. It gives you copy of value
// you mutate this value somewhere in your program and set it back with setter.
pub struct SpiderRobot {
    species: String,
    web_enabled: bool,
    leg_devices: [fd::FileDesc, 8],
    hardware_error_count: Cell<u32>,
}

impl SpiderRobot {
    // Increase the error count by 1
    pub fn add_hardware_error(&self) {
        let n = self.hardware_error_count.get();
        self.hardware_error_count.set(n+1);
    }

    pub fn has_hardware_errors(&self) {
        self.hardware_error_count.get() > 0
    }
}

fn main() {
    SpiderRobot { species, web_enabled, leg_devices, hardware_error_count }
}
