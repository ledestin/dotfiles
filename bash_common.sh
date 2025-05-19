#!/bin/bash

bell() {
  local prev_job_exitcode="$?"
  local task_description="$@"
  local prev_job_status="done"

  if [ "$prev_job_exitcode" -ne 0 ]; then
    prev_job_status="failed"
  fi

  if [ -n "$task_description"  ]; then
    notify-send "Task $prev_job_status: $task_description"
    return
  fi

  notify-send "Task $prev_job_status"
}

set_locale_messages_c_lang_nz() {
  export LC_MESSAGES=C
  if [ -z "$LANG" ]; then
    export LANG=en_NZ.UTF-8
  fi
}

set_node_path() {
  export NODE_PATH=/usr/local/lib/node_modules
}

limit_number_of_user_processes_on_linux() {
  case "$OS" in
    Linux)
      ulimit -u 5000
      ;;
  esac
}

is_interactive_shell() {
  [ -n "$PS1" ]
  return $?
}

fix_macos_no_term_warning() {
  if [ -n "$TERM" ]; then
    export TERM=$TERM
  fi
}

fix_ctrl_o_on_macos() {
  stty discard undef
}
