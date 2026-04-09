package main

import (
	"runtime"
	"testing"
)

func TestStableRuntimeServiceRef(t *testing.T) {
	t.Parallel()
	cases := []struct {
		in, want string
	}{
		{"", ""},
		{"/Users/x/Code/uDOS-family/uDOS-core/contracts/runtime-services.json", "uDOS-core/contracts/runtime-services.json"},
		{"/opt/unknown/path/runtime-services.json", "runtime-services.json"},
		// Forward slashes only: runs on every GOOS; matches Windows output after filepath.ToSlash(filepath.Clean(...)).
		{"C:/Users/dev/Code/uDOS-family/uDOS-core/contracts/runtime-services.json", "uDOS-core/contracts/runtime-services.json"},
	}
	// Windows paths use raw strings so `\u` in `uDOS-core` is not parsed as a Unicode escape.
	if runtime.GOOS == "windows" {
		cases = append(cases,
			struct{ in, want string }{
				`C:\Users\dev\Code\uDOS-family\uDOS-core\contracts\runtime-services.json`,
				"uDOS-core/contracts/runtime-services.json",
			},
			struct{ in, want string }{
				`\\fileserver\family\uDOS-core\contracts\runtime-services.json`,
				"uDOS-core/contracts/runtime-services.json",
			},
		)
	}
	for _, tc := range cases {
		got := stableRuntimeServiceRef(tc.in)
		if got != tc.want {
			t.Errorf("stableRuntimeServiceRef(%q) = %q; want %q", tc.in, got, tc.want)
		}
	}
}
