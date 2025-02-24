#!/bin/bash

echo "1-nano, 2-vi, 3-links, 4-exit"

read command

case $command in
  1)
    nano;;
  2)
    vi;;
  3)
    links;;
  4)
    echo "Exit"
    exit 0
    ;;
  *)
    echo "Invalid choice";;
esac
