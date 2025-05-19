#!/bin/bash

for i in {1..20}
do
  ./measure.sh "$i" seq
  ./measure.sh "$i" par
done
