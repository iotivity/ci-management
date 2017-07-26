if $::kernel == 'windows' {
  Package { provider => chocolatey,
            install_options => ['-y',],
	  }
#  if $::architecture == 'i386' {
#    Package { provider => chocolatey,
#              install_options => ['-y','--x86',], }
#  }

# not choco packaged:
# KB2504637 KB2664825 KB2829760 KB2894856 KB2938066 KB2977765 KB3008242
# KB3010788 KB3013538 KB3013791 KB3021674 KB3022777 KB3024755 KB3027209
# KB3036612 KB3037924 KB3041857 KB3045563 KB3045685 KB3045717 KB3045717
# KB3045755 KB3055323 KB3055343 KB3055642 KB3059316 KB3060793 KB3063843
# KB3071663 KB3076895 KB3080042 KB3081320 KB3081320 KB3086255 KB3087137
# KB3094486 KB3100473 KB3102467 KB3102930 KB3108381  

# not installed after this run:
# 'KB2999226','KB3045563','KB3102467'

# requires reboot
# 'KB3045563','KB3102467','KB2999226'

  $kblist = [
	       'KB2504637','KB2664825','KB2829760','KB2882822','KB2894856',
	       'KB2919355','KB2919442','KB2938066','KB2977765','KB2999226',
	       'KB3008242','KB3010788','KB3013538','KB3013791','KB3021674',
	       'KB3022777','KB3024755','KB3027209','KB3033929','KB3035131',
	       'KB3036612','KB3037924','KB3041857','KB3045563','KB3045685',
	       'KB3045717','KB3045755','KB3055323','KB3055343','KB3055642',
	       'KB3059316','KB3060793','KB3063843','KB3071663','KB3076895',
	       'KB3080042','KB3081320','KB3086255','KB3087137','KB3094486',
	       'KB3100473','KB3102467','KB3102930','KB3108381','KB3109103',
	       'KB3109976','KB3110329','KB3126587','KB3133924','KB3134815',
	       'KB3138602','KB3139162','KB3139164','KB3139165','KB3146723',
	       'KB3146978','KB3156059','KB3161949','KB3161958','KB4038792'
  ]
  $kblist.each |$item| {
    windows_updates::kb {"knowledge base $item": ensure => 'present', kb => $item }
  }

  include chocolatey

#  dsc_windowsfeature {'AspNet45':
#    dsc_ensure => 'present',
#    dsc_name   => 'Web-Asp-Net45',
#  }

}

$packages= [ 'git','curl','dotnet4.5.1','cmake','jdk8',
             'sqlite','python2','7zip.install','nssm','vim',
             'strawberryperl' ]

package { $packages: ensure => latest, }

reboot { 'after_run':
  apply  => finished,
}

