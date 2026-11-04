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

init_storage() {
    local dir
    dir=$(dirname "$DATA_FILE")
    mkdir -p "$dir" || die "cannot create folder '$dir'"
    touch "$DATA_FILE" || die "cannot create file '$DATA_FILE'"
}

next_id() {
    awk -F'|' 'BEGIN { max = 0 } $1 > max { max = $1 } END { print max + 1 }' "$DATA_FILE"
}

cmd_add() {
    init_storage
    local title="$*"
    local id 
    id=$(next_id)

    echo "$id|todo|medium|$title" >> "$DATA_FILE"
    echo "added task $id"
}

cmd_list() {
    init_storage

    if [[ ! -s "$DATA_FILE" ]]; then
        echo "no tasks yet, add one with: todo.sh add \"your task\""
        return
    fi

    printf "%-3s %-7s %-9s %s\n" ID status priority title

    while IFS='|' read -r id status priority title; do 
        printf "%-3s %-7s %-9s %s\n" "$id" "$status" "$priority" "$title"
    done < "$DATA_FILE"
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