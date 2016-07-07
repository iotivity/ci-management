# Uncomment this to delete jobs not managed by JJB on upload
#jenkins-jobs update --delete-old --recursive jjb/
jenkins-jobs update --recursive jjb/

# Submit patches for any jobs that can be auto updated
function submitJJB {
    git commit -asm "Automated update of project templates"
    git push origin HEAD:refs/for/master
}

gitdir=$(git rev-parse --git-dir); scp -p -P 29418 iotivity-jobbuilder@gerrit.iotivity.org:hooks/commit-msg ${gitdir}/hooks/
git diff --exit-code || submitJJB
