use std::cell::Cell;

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
