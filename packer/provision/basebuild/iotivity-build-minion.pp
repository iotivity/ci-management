if $::kernel == 'windows' {
  Package { provider => chocolatey,
            install_options => ['-y',],
	  }
#  if $::architecture == 'i386' {
#    Package { provider => chocolatey,
#              install_options => ['-y','--x86',], }
#  }
  $packages= [ 'git','curl','DotNet4.5','dotnet4.5.1','cmake','jdk8',
               'sqlite','python2','7zip.install','nssm',
               'strawberryperl','vcredist140',
	       'KB2504637','KB2919355','KB2919442','KB2999226','KB3033929','KB3035131' ]
}

include chocolatey


package { $packages: ensure => latest, }
