class controller_yoga ($cloud_role_foreman = "undefined") {

  $cloud_role = $cloud_role_foreman

  $ocatapackages = [ "crudini",

                   ]


     package { $ocatapackages: ensure => "installed" }

  # Install CA
  class {'controller_yoga::install_ca_cert':}

  # Ceph
  class {'controller_yoga::ceph':}
  
  # Configure keystone
  class {'controller_yoga::configure_keystone':}
  
  # Configure glance
  class {'controller_yoga::configure_glance':}

  # Configure nova
  class {'controller_yoga::configure_nova':}

## FF for placement in xena
  # Configure placement
  class {'controller_yoga::configure_placement':}
###

  # Configure ec2
  class {'controller_yoga::configure_ec2':}

  # Configure neutron
  class {'controller_yoga::configure_neutron':}

  # Configure cinder
  class {'controller_yoga::configure_cinder':}

  # Configure heat
  class {'controller_yoga::configure_heat':}

  # Configure horizon
  class {'controller_yoga::configure_horizon':}

  # Configure Shibboleth if AII and Shibboleth are enabled
  if ($::controller_yoga::params::enable_aai_ext and $::controller_yoga::params::enable_shib)  {
    class {'controller_yoga::configure_shibboleth':}
  }

  # Configure OpenIdc if AII and openidc are enabled
  if ($::controller_yoga::params::enable_aai_ext and ($::controller_yoga::params::enable_oidc or $::controller_yoga::params::enable_infncloud))  {
    class {'controller_yoga::configure_openidc':}
  }
 
  # Service
  class {'controller_yoga::service':}

  
  # do passwdless access
  class {'controller_yoga::pwl_access':}
  
  
  # configure remote syslog
  class {'controller_yoga::rsyslog':}
  
  

       Class['controller_yoga::install_ca_cert'] -> Class['controller_yoga::configure_keystone']
       Class['controller_yoga::configure_keystone'] -> Class['controller_yoga::configure_glance']
       Class['controller_yoga::configure_glance'] -> Class['controller_yoga::configure_nova']
       Class['controller_yoga::configure_nova'] -> Class['controller_yoga::configure_placement']
       Class['controller_yoga::configure_placement'] -> Class['controller_yoga::configure_neutron']
       Class['controller_yoga::configure_neutron'] -> Class['controller_yoga::configure_cinder']
       Class['controller_yoga::configure_cinder'] -> Class['controller_yoga::configure_horizon']
       Class['controller_yoga::configure_horizon'] -> Class['controller_yoga::configure_heat']

  }
