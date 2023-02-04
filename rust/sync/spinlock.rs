// Version with an unsafe unlock of UnsafeCell

pub struct SpinLock {
    locked: AtomicBool,
}

impl<T> SpinLock<T> {
    pub const fn new(value: T) -> Self {
        Self {
            locked: AtomicBool::new(false),
            value: UnsafeCell::new(value),
        }
    }

    // we should limit the lifetime of &mut T here
    // it should be ended as soon as we call unlock,
    // but there is no easy way to implement it
    // we should drop &mut T the same moment we drop this object
    pub fn lock(&self) -> &mut T {
        while self.locked.swap(true, Acquire) {
            std::hint::spin_loop();
        }
        unsafe { &mut *self.value.get() }
    }

    // Safety: The &mut T from lock() must be gone!
    // (And no cheating by keeping reference to fields of that T around!)
    pub unsafe fn unlock(&self) {
        self.locked.store(false, Release);
    }
}
