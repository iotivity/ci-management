#!/bin/bash

rm -rf job_output_prev
rm -rf job_output

jenkins-jobs -l ERROR test -r jjb -o job_output

git checkout -q -b master-one HEAD^ && jenkins-jobs -l ERROR test -r jjb -o job_output_prev

diff -r -u0 job_output_prev job_output &> job_diff.txt
# Add a space at the beginning of each line so Gerrit sees it as a block
# comment
sed -i.bak 's/^/ /' job_diff.txt

git checkout -q - && git branch -q -d master-one
