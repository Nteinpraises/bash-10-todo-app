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

    local priority="medium" opt OPTIND=1
    while getopts ":p:" opt; do
        case "$opt" in
            p) priority="$OPTARG" ;;
            *) die "usage: add [-p low|medium|high] TITLE" ;;
        esac
    done
    shift $((OPTIND - 1))
    local title="$*"

    case "$priority" in
        low|medium|high) ;;
        *) die "priority must be low, medium or high (got '$priority')" ;;
    esac

    [[ -n "${title// /}" ]] || die "add needs a title"
    [[ "$title" != *"|"* ]] || die "the title cannot contain the | character"

    local id
    id=$(next_id)
    echo "$id|todo|$priority|$title" >> "$DATA_FILE"
    echo "Added task $id"
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

cmd_done() {
    init_storage
    local id="$1"
    local tmp
    tmp=$(mktemp "$DATA_FILE.XXXXXX")

    awk -F'|' -v OFS='|' -v id="$id" '$1 == id { $2 = "done" } { print }' "$DATA_FILE" > "$tmp"
    mv "$tmp" "$DATA_FILE"

    echo "Task $id done"
}

cmd_delete() {
    init_storage
    local id="$1"
    local tmp
    tmp=$(mktemp "$DATA_FILE.XXXXXX")

    awk -F'|' -v id="$id" '$1 != id' "$DATA_FILE" > "$tmp"
    mv "$tmp" "$DATA_FILE"

    echo "Task $id deleted"
}

main() {
    local subcommand="${1:-list}"
    [[ $# -gt 0 ]] && shift

    case "$subcommand" in
        add) cmd_add "$@" ;;
        list) cmd_list ;;
        help) cmd_help ;;
        done) cmd_done "$@" ;;
        delete) cmd_delete "$@" ;;
        *) die "unknown command '$subcommand'" ;;
    esac
}

main "$@"