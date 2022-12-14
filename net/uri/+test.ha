use fmt;
use net::ip;

@test fn roundtrip() void = {
	test_uri_roundtrip(
		"file:///my/path/to/file",
		uri {
			scheme = "file",
			host = "",
			path = "/my/path/to/file",
			...
		},
	)!;
	test_uri_roundtrip(
		"http://harelang.org/",
		uri {
			scheme = "http",
			host = "harelang.org",
			path = "/",
			...
		},
	)!;
	test_uri_roundtrip(
		"irc+insecure://chat.sr.ht:6667",
		uri {
			scheme = "irc+insecure",
			host = "chat.sr.ht",
			port = 6667,
			...
		},
	)!;
	test_uri_roundtrip(
		"ldap://13.37.73.31:1234/",
		uri {
			scheme = "ldap",
			host = [13, 37, 73, 31]: ip::addr4,
			port = 1234,
			path = "/",
			...
		},
	)!;
	test_uri_roundtrip(
		"http://[::1]/test",
		uri {
			scheme = "http",
			host = ip::parse("::1")!,
			path = "/test",
			...
		},
	)!;

	// Some non-URL variants like mailto: or URN
	test_uri_roundtrip(
		"urn:example:animal:ferret:nose",
		uri {
			scheme = "urn",
			host = "",
			path = "example:animal:ferret:nose",
			...
		},
	)!;
	test_uri_roundtrip(
		"mailto:~sircmpwn/hare-dev@lists.sr.ht",
		uri {
			scheme = "mailto",
			host = "",
			path = "~sircmpwn/hare-dev@lists.sr.ht",
			...
		},
	)!;

};

@test fn invalid() void = {
	// Scheme
	assert(parse(":") is invalid);
	assert(parse("hello*:") is invalid);
	assert(parse("hello") is invalid);
};

@test fn percent_encoding() void = {
	test_uri(
		"https://git%2esr.ht/~sircmpw%6e/hare#Build%20status",
		uri {
			scheme = "https",
			host = "git.sr.ht",
			path = "/~sircmpwn/hare",
			fragment = "Build status",
			...
		},
		"https://git.sr.ht/~sircmpwn/hare#Build%20status",
	)!;

	// IPv6
	test_uri(
		"ldap://[2001:db8::7]/c=GB?objectClass?one",
		uri {
			scheme = "ldap",
			host = ip::parse("2001:db8::7")!,
			path = "/c=GB",
			query = "objectClass?one",
			...
		},
		"ldap://[2001:db8::7]/c=GB?objectClass%3Fone",
	)!;

	// https://bugs.chromium.org/p/chromium/issues/detail?id=841105
	test_uri(
		"https://web-safety.net/..;@www.google.com:%3443",
		uri {
			scheme = "https",
			host = "web-safety.net",
			path = "/..;@www.google.com:443",
			...
		},
		"https://web-safety.net/..;@www.google.com:443",
	)!;
};

fn test_uri_roundtrip(in: str, expected: uri) (void | invalid) = {
	test_uri(in, expected, in)?;
};

fn test_uri(in: str, expected_uri: uri, expected_str: str) (void | invalid) = {
	const u = parse(in)?;
	defer finish(&u);

	assert(u.scheme == expected_uri.scheme);
	match (u.host) {
	case let s: str =>
		assert(s == expected_uri.host as str);
	case let i: ip::addr =>
		assert(ip::equal(i, expected_uri.host as ip::addr));
	};
	assert(u.port == expected_uri.port);
	assert(u.userinfo == expected_uri.userinfo);
	assert(u.path == expected_uri.path);
	assert(u.query == expected_uri.query);
	assert(u.fragment == expected_uri.fragment);

	const s = string(&u);
	defer free(s);

	if (s != expected_str) {
		fmt::errorfln("=== wanted\n{}", expected_str)!;
		fmt::errorfln("=== got\n{}", s)!;
		abort();
	};
};
