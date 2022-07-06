#!/bin/bash

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
