#! /bin/bash
# Jenkins Job Diff

rm -rf job_output_prev
rm -rf job_output

jenkins-jobs -l ERROR test -r jjb -o job_output

git checkout -q -b master-one HEAD^ && jenkins-jobs -l ERROR test -r jjb -o job_output_prev

diff -ru job_output_prev job_output &> job_diff.txt

git checkout -q master && git branch -q -d master-one
