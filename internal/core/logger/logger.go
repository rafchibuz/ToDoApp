package core_loger

import (
	"fmt"
	"os"

	"go.uber.org/zap"
)

type Logger struct {
	*zap.Logger

	file *os.File
}

func NewLogger() (*Logger, error) {
	zapLvl := zap.NewAtomicLevel()
	if err := zapLvl.UnmarshalText([]byte(logLevel)); err != nil {
		return nil, fmt.Errorf("unmarshal log level: %w", err)
	}

}
