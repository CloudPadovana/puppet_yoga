class compute_yoga ($cloud_role_foreman = "undefined") { 

  $cloud_role = $cloud_role_foreman  

  # system check setting (network, selinux, CA files)
    class {'compute_yoga::systemsetting':}

  # stop services 
    class {'compute_yoga::stopservices':}

  # install
    class {'compute_yoga::install':}

  # setup firewall
    class {'compute_yoga::firewall':}

  # setup bacula
    class {'compute_yoga::bacula':}
  
  # setup libvirt
    class {'compute_yoga::libvirt':}

  # setup ceph
    class {'compute_yoga::ceph':}

  # setup rsyslog
    class {'compute_yoga::rsyslog':}

  # service
    class {'compute_yoga::service':}

  # install and configure nova
     class {'compute_yoga::nova':}

  # install and configure neutron
     class {'compute_yoga::neutron':}

  # nagios settings
     class {'compute_yoga::nagiossetting':}

  # do passwdless access
      class {'compute_yoga::pwl_access':}

    # configure collectd
      class {'compute_yoga::collectd':}


# execution order
             Class['compute_yoga::firewall'] -> Class['compute_yoga::systemsetting']
             Class['compute_yoga::systemsetting'] -> Class['compute_yoga::stopservices']
             Class['compute_yoga::stopservices'] -> Class['compute_yoga::install']
             Class['compute_yoga::install'] -> Class['compute_yoga::bacula']
             Class['compute_yoga::bacula'] -> Class['compute_yoga::nova']
             Class['compute_yoga::nova'] -> Class['compute_yoga::libvirt']
             Class['compute_yoga::libvirt'] -> Class['compute_yoga::neutron']
             Class['compute_yoga::neutron'] -> Class['compute_yoga::ceph']
             Class['compute_yoga::ceph'] -> Class['compute_yoga::nagiossetting']
             Class['compute_yoga::nagiossetting'] -> Class['compute_yoga::pwl_access']
             Class['compute_yoga::pwl_access'] -> Class['compute_yoga::collectd']
             Class['compute_yoga::collectd'] -> Class['compute_yoga::service']
################           
}
  
