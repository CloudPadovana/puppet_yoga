class controller_yoga::configure_horizon inherits controller_yoga::params {

  file { "/etc/httpd/conf.d/ssl.conf":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => "0644",
    content  => template("controller_yoga/ssl.conf.erb"),
  }
  
  file { "/etc/httpd/conf.d/openstack-dashboard.conf":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => "0644",
    content  => file("controller_yoga/openstack-dashboard.conf"),
  }
 
  file { "/etc/openstack-dashboard/local_settings":
    ensure   => file,
    owner    => "root",
    group    => "apache",
    mode     => "0640",
    content  => template("controller_yoga/local_settings.erb"),
  }

  file { '/var/log/horizon/horizon_log':
    path    => '/var/log/horizon/horizon.log',
    ensure  => 'present',
    owner   => 'apache',
    group   => 'apache',
    mode     => "0644",
  }

#  exec { "port_80_closed":
#    command => "/usr/bin/sed -i -e 's|^Listen\\s*80\\s*|#Listen 80|g' /etc/httpd/conf/httpd.conf" ,
#    unless  => "/bin/grep '#Listen\\s*80\\s*$' /etc/httpd/conf/httpd.conf",
#  }


  ############################################################################
  #  OS-Federation
  ############################################################################
  if $enable_aai_ext {
 
    exec { "download_cap_repo":
      command => "/usr/bin/wget -q -O /etc/yum.repos.d/openstack-security-integrations.repo ${cap_repo_url}",
      unless  => "/bin/grep Yoga /etc/yum.repos.d/openstack-security-integrations.repo 2>/dev/null >/dev/null",
    }

    package { ["openstack-auth-cap", "openstack-auth-shib"]:
      ensure  => latest,
      require => Exec["download_cap_repo"],
    }
  
    file { "/usr/share/openstack-dashboard/openstack_dashboard/local/local_settings.d/_1002_aai_settings.py":
      ensure   => file,
      owner    => "root",
      group    => "apache",
      mode     => "0640",
      content  => template("controller_yoga/aai_settings.py.erb"),
    }

    file { "/usr/share/openstack-dashboard/openstack_dashboard/local/local_settings.d/_1003_infnaai_settings.py":
      ensure   => file,
      owner    => "root",
      group    => "apache",
      mode     => "0640",
      content  => template("controller_yoga/infnaai_settings.py.erb"),
    }

    file { "/usr/share/openstack-dashboard/openstack_dashboard/local/local_settings.d/_1003_unipdsso_settings.py":
      ensure   => file,
      owner    => "root",
      group    => "apache",
      mode     => "0640",
      content  => template("controller_yoga/unipdsso_settings.py.erb"),
    }

    file { "/usr/share/openstack-dashboard/openstack_dashboard/local/local_settings.d/_1003_oidc_settings.py":
      ensure   => file,
      owner    => "root",
      group    => "apache",
      mode     => "0640",
      content  => template("controller_yoga/oidc_settings.py.erb"),
    }

    file { "/etc/openstack-auth-shib/notifications/notifications_en.txt":
      ensure   => file,
      owner    => "root",
      group    => "root",
      mode     => "0644",
      content  => template("controller_yoga/notifications_en.txt.erb"),
      require  => Package["openstack-auth-cap"],
    }


  ### DB Creation if not exist and grant privileges.

    package { "mariadb":
      ensure  => installed,
    }

    exec { "create-$aai_db_name-db":
        command => "/usr/bin/mysql -u root -p${mysql_admin_password} -h ${aai_db_host} -e \"create database IF NOT EXISTS ${aai_db_name}; grant all on ${aai_db_name}.* to ${aai_db_user}@localhost identified by '${aai_db_pwd}'; grant all on ${aai_db_name}.* to ${aai_db_user}@'${vip_mgmt}' identified by '${aai_db_pwd}'; grant all on ${aai_db_name}.* to ${aai_db_user}@'${ip_ctrl1}' identified by '${aai_db_pwd}'; grant all on ${aai_db_name}.* to ${aai_db_user}@'${ip_ctrl2}' identified by '${aai_db_pwd}';\"",
        unless  => "/usr/bin/mysql -u root -p${mysql_admin_password} -h ${aai_db_host} -e \"show DATABASES LIKE '${aai_db_name}';\"",
        require => Package["mariadb"],
    }

  }

  ############################################################################
  #  Cron-scripts configuration
  ############################################################################

  file { "/etc/openstack-auth-shib/actions.conf":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => "0600",
    content  => template("controller_yoga/actions.conf.erb"),
  }
  
  if "${::fqdn}" =~ /01/ {
    $chk_exp_schedule = "5 0 * * 0,2,4,6"
    $noti_exp_schedule = "10 0 * * 0,2,4,6"
    $renew_schedule = "15 0 * * *"
    $chk_gate_schedule = "0 6-20 * * *"
  } else {
    $chk_exp_schedule = "5 0 * * 1,3,5"
    $noti_exp_schedule = "10 0 * * 1,3,5"
    $renew_schedule = "30 0 * * *"
    $chk_gate_schedule = "30 6-20 * * *"
  }
  
  file { "/etc/cron.d/openstack-auth-shib-cron":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => '0644',
    content  => template("controller_yoga/openstack-auth-shib-cron.erb"),
  }

  ############################################################################
  #  Memcached configuration
  ############################################################################

  file_line { 'memcached sysconfig':
    ensure => present,
    path   => '/etc/sysconfig/memcached',
    line   => "OPTIONS=\"-l $::mgmtnw_ip\"",
    match  => 'OPTIONS'
  }
}
