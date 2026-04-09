package screens

import "embed"

// Golden holds canonical screen fixtures; keep byte-identical to the sibling *.txt files.
//
//go:embed *.txt
var Golden embed.FS
