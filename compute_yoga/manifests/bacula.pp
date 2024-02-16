class compute_yoga::bacula {

include compute_yoga::params

$baculapackages = [ "bacula-client" , "bacula-libs", "bacula-common" ]


case $operatingsystemrelease {
    /^7.*/: {
             package { $baculapackages: ensure => "installed" }
             service { "bacula-fd":
                       ensure => running,
                       enable => true,
                       hasstatus => true,
                       hasrestart => true,
                       require => Package["bacula-client"],
                     }
            }
    /^8.*/: {
  
              package { $baculapackages: ensure => "purged" }

              package {"bareos-common":
                 provider => "rpm",
                 ensure   => installed,
                 source => "https://download.bareos.org/bareos/release/19.2/CentOS_8/x86_64/bareos-common-19.2.7-2.el8.x86_64.rpm",
                      }  
 
              package {"bareos-filedaemon":
                 provider => "rpm",
                 ensure   => installed,
                 source => "https://download.bareos.org/bareos/release/19.2/CentOS_8/x86_64/bareos-filedaemon-19.2.7-2.el8.x86_64.rpm",
                 require => Package["bareos-common"],
                      }  
  
              service { "bareos-fd":
                 ensure => running,
                 enable => true,
                 hasstatus => true,
                 hasrestart => true,
                 require => Package["bareos-filedaemon"],
                      }

            }
    /^9.*/: {
  
              package { $baculapackages: ensure => "purged" }

              package {"bareos-common":
                 provider => "rpm",
                 ensure   => installed,
                 source => "http://cld-config.cloud.pd.infn.it:8090/bareos/bareos-common-23.0.2~pre53.e52dbae7a-53.el9.x86_64.rpm",
                      }  
 
              package {"bareos-filedaemon":
                 provider => "rpm",
                 ensure   => installed,
                 source => "http://cld-config.cloud.pd.infn.it:8090/bareos/bareos-filedaemon-23.0.2~pre53.e52dbae7a-53.el9.x86_64.rpm",
                 require => Package["bareos-common"],
                      }  
  
              service { "bareos-fd":
                 ensure => running,
                 enable => true,
                 hasstatus => true,
                 hasrestart => true,
                 require => Package["bareos-filedaemon"],
                      }

            }
}
}
