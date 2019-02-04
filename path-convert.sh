#!/bin/bash
declare -a NEW_ARGS

for var in "$@"
do
  if [[ "$var" =~ ^[a-zA-Z]:\\ ]]; then
    NEW_ARGS+=("$(wslpath "$var")")
  else
    NEW_ARGS+=("$var")
  fi
done

"${NEW_ARGS[@]}"
