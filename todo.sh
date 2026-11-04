#!/bin/bash

DATA_FILE="${TODO_FILE:-$HOME/.local/share/todo/todo.txt}"

die() {
    echo "Error: $*" >&2
    exit 1
}

cmd_help() {
    cat << 'EOF'
    Usage: todo.sh Command [Arguments]

    Commands:
        add [-p low|medium|high] Title      add a task
        list                                show all tasks
        done ID                             mark a task as done
        delete ID                           delete a talk
        help                                show this message
EOF
}

cmd_add() {
    echo "add: not built yet ($*)"
}

cmd_list() {
    echo "list: not yet built"
}

main() {
    local subcommand="${1:-list}"
    [[ $# -gt 0 ]] && shift

    case "$subcommand" in
        add) cmd_add "$@" ;;
        list) cmd_list ;;
        help) cmd_help ;;
        *) die "unknown command '$subcommand'" ;;
    esac
}

main "$@"