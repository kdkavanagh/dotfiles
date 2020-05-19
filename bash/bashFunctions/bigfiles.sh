function bigfiles() {
    du -a . | sort -n -r | head -n ${1:-20}
}