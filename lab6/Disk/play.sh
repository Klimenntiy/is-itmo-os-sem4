#!/bin/bash

./gen_files.sh

for i in {1..20}
do
  ./measure.sh "$i" seq
  ./measure.sh "$i" par
done
