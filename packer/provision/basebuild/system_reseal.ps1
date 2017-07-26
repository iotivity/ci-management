$openssh_root="C:\Program Files\OpenSSH-Win64"

$keytypes = @('dsa','ecdsa','ed25519','rsa')
foreach ($type in $keytypes) {
  rm "$openssh_root\ssh_host_"+$type+"_key*"
}
