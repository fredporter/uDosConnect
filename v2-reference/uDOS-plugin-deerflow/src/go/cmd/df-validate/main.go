package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type Translation struct {
	WorkflowID string `json:"workflowId"`
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("usage: df-validate <translation.json>")
		os.Exit(1)
	}

	data, err := os.ReadFile(os.Args[1])
	if err != nil {
		fmt.Println("read error:", err)
		os.Exit(1)
	}

	var t Translation
	if err := json.Unmarshal(data, &t); err != nil {
		fmt.Println("json error:", err)
		os.Exit(1)
	}

	if t.WorkflowID == "" {
		fmt.Println("validation failed: workflowId missing")
		os.Exit(1)
	}

	fmt.Println("ok:", t.WorkflowID)
}
