// License: MPL-2.0
// (c) 2021 Mykyta Holubakha <hilobakho@gmail.com>

// TODO: work when _NSIG != 64

export fn sigemptyset(set: *sigset) void = {
	set.__val[0] = 0;
};

export fn sigaddset(set: *sigset, signum: int) (void | errno) = {
	if (signum < 1 || signum > NSIG) {
		return wrap_errno(EINVAL);
	};
	signum -= 1;
	set.__val[0] |= (1 << signum): u64;
};

export fn sigdelset(set: *sigset, signum: int) (void | errno) = {
	if (signum < 1 || signum > NSIG) {
		return wrap_errno(EINVAL);
	};
	signum -= 1;
	set.__val[0] &= ~(1 << signum: u64);
};

export fn sigismember(set: *sigset, signum: int) (bool | errno) = {
	if (signum < 1 || signum > NSIG) {
		return wrap_errno(EINVAL);
	};
	signum -= 1;
	return (set.__val[0] & (1 << signum: u64)) != 0;
};

export fn sigfillset(set: *sigset) void = {
	set.__val[0] = ~0u64;
};
