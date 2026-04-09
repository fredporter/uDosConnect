//go:build !windows

package localexec

import "errors"

func execErrorAs(err error, target any) bool {
	return errors.As(err, target)
}
