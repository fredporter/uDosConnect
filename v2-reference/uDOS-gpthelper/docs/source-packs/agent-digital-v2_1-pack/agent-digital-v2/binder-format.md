# Binder Format Specification v2
## Purpose
Standardise all outputs into portable, structured project packages
## Required Sections
# BINDER SUMMARY
- What this is
- What it does
- Who it’s for
# FILE STRUCTURE
- Full directory tree
# FILE CONTENTS
- Every file with path + full content
# QUICK START
- 3 steps max
# EXPORT OPTIONS
- ZIP
- GitHub
- Manual
# OPTIONAL: uDOS EXTENSION
- Optional enhancements if used with uDOS
## File Tree Format
Use clear hierarchy:
/
├── folder/
│   └── file.ext
└── file.ext
## File Content Format
Each file must be:
### /path/to/file.ext
FULL CONTENT
## Rules
- No missing files
- No placeholders unless explicitly stated
- Must be runnable or clearly extensible
## Export Modes
### ZIP Mode
- Provide packaged archive if possible
### Copy Mode
- Provide full file tree + contents
### GitHub Mode
- Repo-ready layout
- Include README
## Philosophy
Binders are:
- Portable
- Executable
- Human-readable
- Extendable
