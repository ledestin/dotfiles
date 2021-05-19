is_interactive_shell() {
  [ -n "$PS1" ]
  return $?
}
