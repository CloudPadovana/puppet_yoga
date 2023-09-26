class controller_yoga::rsyslog inherits controller_yoga::params {

#
# Questa classe configura rsyslog in modo da centralizzare i log su cld-foreman
#
     $rsyslogpackages = [ "rsyslog" ]
  
     package { $rsyslogpackages: ensure => "installed" }
  
    
      service { "rsyslog":
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
        require => Package["rsyslog"],
      }

      file {'rsyslog_conf':
          source      => 'puppet:///modules/controller_yoga/rsyslog.conf',
          path        => '/etc/rsyslog.conf',
          backup      => true,
          owner   => root,
          group   => root,
          mode    => "0644",
          notify => Service['rsyslog'],
         }

      file {'ignore_nagios':
          source      => 'puppet:///modules/controller_yoga/ignore-systemd-session-slice-nagios.conf',
          path        => '/etc/rsyslog.d/ignore-systemd-session-slice-nagios.conf',
          backup      => true,
          owner   => root,
          group   => root,
          mode    => "0644",
          notify => Service['rsyslog'],
         }
}
