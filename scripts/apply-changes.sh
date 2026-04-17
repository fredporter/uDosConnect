# Example: Add a new function to modify a file
modify_file() {
    local file="$1"
    local content="$2"
    echo "$content" > "$file"
    echo "Modified $file"
}
modify_file "test.txt" "Hello, world!"
