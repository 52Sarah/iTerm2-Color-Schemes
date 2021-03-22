#!/usr/bin/env bash

bg() {
  local f
  for f in "$@"; do
    local scheme="$(basename "${f%.*}")"

    for elem in 'Background'; do
      read -r dec_b dec_g dec_r <<< "$(grep -A 10 "$elem Color" "$f" |\
        grep '<real>' |\
        sed -E 's%^[[:blank:]]*<real>(1|0.[[:digit:]]{1,6}).*\</real\>[[:blank:]]*$%\1%;' |\
        join-lines ' ')"

      local rgb_r="$(printf "%d" "$(bc <<< "($dec_r * 255 + 0.49) / 1")")"
      local rgb_g="$(printf "%d" "$(bc <<< "($dec_g * 255 + 0.49) / 1")")"
      local rgb_b="$(printf "%d" "$(bc <<< "($dec_b * 255 + 0.49) / 1")")"

      local hex_r="$(printf "%'02s" "$(bc <<< "obase=16; $rgb_r")")"
      local hex_g="$(printf "%'02s" "$(bc <<< "obase=16; $rgb_g")")"
      local hex_b="$(printf "%'02s" "$(bc <<< "obase=16; $rgb_b")")"
      
      printf "Scheme:\t%-30s\tElement:\t%s\trgb:\t%3d\t%3d\t%3d\thex:\t%2s\t%2s\t%2s\n" "$scheme" "$elem" $rgb_r $rgb_g $rgb_b $hex_r $hex_g $hex_b 

    done
  done
}
bg "$@"
