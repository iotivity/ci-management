BUILD_ROOTS="GBS-ROOT GBS-ROOT-RI GBS-ROOT-ES GBS-ROOT-OIC GBS-ROOT-RI-OIC"

# link tizen's gbs cache to expected location
IOTIVITYEXTLIB=/extlibs
sudo chown -R ${USER}:${USER} ${IOTIVITYEXTLIB}/GBS
ln -s ${IOTIVITYEXTLIB}/GBS/* ${HOME}/

for build_dir in $BUILD_ROOTS; do
  if [ -d "$HOME/${build_dir}" ]; then
    echo "$build_dir Exists. Ensuring clean chroot"
    chroot_dir="$HOME/${build_dir}/local/BUILD-ROOTS/scratch.armv7l.0"
    [ -d $chroot_dir/proc ] && sudo /bin/umount -l -f $chroot_dir/proc || true
    [ -d $chroot_dir/dev/pts ] && sudo /bin/umount -l -f $chroot_dir/dev/pts || true
    [ -d $chroot_dir/dev/shm ] && sudo /bin/umount -l -f $chroot_dir/dev/shm || true
  fi
done
