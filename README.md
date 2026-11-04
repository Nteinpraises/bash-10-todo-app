# To-Do App

This Bash script, `todo.sh`, manages a to-do list from the terminal.

## Problem Statement

Developers spend their day in the terminal, so checking tasks should not
mean opening another app. `todo.sh` adds, lists, completes and deletes tasks
with one short command each.

## Tech Stack

- Bash
- awk, sort and cut
- Git and GitHub (feature branch and pull request workflow)

## Installation

```bash
git clone https://github.com/Nteinpraises/bash-10-todo-app.git
cd bash-10-todo-app
chmod +x todo.sh
```

## Commands

Add a task. The priority is optional (low, medium or high) and defaults to
medium. The `-p` option must come before the title:

```text
$ ./todo.sh add "Finish grade report"
Added task 1
$ ./todo.sh add -p high "Submit Day 9 fixes"
Added task 2
```

List all tasks, high priority first:

```text
$ ./todo.sh list
ID  STATUS  PRIORITY  TITLE
2   todo    high      Submit Day 9 fixes
1   todo    medium    Finish grade report
```

Mark a task as done:

```text
$ ./todo.sh done 1
Task 1 done
```

Delete a task:

```text
$ ./todo.sh delete 2
Task 2 deleted
```

Show the help message:

```bash
./todo.sh help
```

Running `./todo.sh` with no arguments shows the list, or a friendly message
when there are no tasks yet.

## Where Tasks Are Stored

Tasks are saved in `~/.local/share/todo/todo.txt`, one per line in the
format `id|status|priority|title`. Set the `TODO_FILE` variable to use
another file, which is useful for testing:

```bash
export TODO_FILE=/tmp/todo-test.txt
```

New tasks get the highest existing ID plus one. `done` and `delete` write
the result to a temporary file and then replace the original with `mv`.

## Errors

Each of these prints a message on stderr and exits with status 1:

- `done` or `delete` with a missing, non-numeric or unknown ID
- `add` with no title
- A title containing the `|` character
- A priority other than low, medium or high
- An unknown command

## screenshot

![alt text](<assets/img/Pasted image.png>)

## Known Limits

- Deleting the task with the highest ID means the next task reuses that ID.
- Titles cannot contain the `|` character.
- IDs above 999 misalign the columns.

## Author

Ntein Praises
