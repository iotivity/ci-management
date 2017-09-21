if $::kernel == 'windows' {
  Package { provider => chocolatey,
            install_options => ['-y',],
	  }
#  if $::architecture == 'i386' {
#    Package { provider => chocolatey,
#              install_options => ['-y','--x86',], }
#  }
  $packages= [ 'git','curl','dotnet4.5.1','cmake','jdk8',
               'sqlite','python2','7zip.install','nssm',
	       'strawberryperl','KB2919442','kb2919442' ]
}

include chocolatey


package { $packages: ensure => latest, }
