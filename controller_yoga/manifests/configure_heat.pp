class controller_yoga::configure_heat inherits controller_yoga::params {
#
# Questa classe:
# - popola il file /etc/heat/heat.conf
# 
  
define do_config ($conf_file, $section, $param, $value) {
             exec { "${name}":
                              command     => "/usr/bin/crudini --set ${conf_file} ${section} ${param} \"${value}\"",
                              require     => Package['crudini'],
                              unless      => "/usr/bin/crudini --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                  }
       }

define remove_config ($conf_file, $section, $param, $value) {
             exec { "${name}":
                              command     => "/usr/bin/crudini --del ${conf_file} ${section} ${param}",
                              require     => Package['crudini'],
                              onlyif      => "/usr/bin/crudini --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                   }
       }
                                                                                                                                             
  
# heat.conf

  controller_yoga::configure_heat::do_config { 'heat_transport_url':
    conf_file => '/etc/heat/heat.conf',
    section   => 'DEFAULT',
    param     => 'transport_url',
    value     => $controller_yoga::params::transport_url,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_metadata_server_url':
    conf_file => '/etc/heat/heat.conf',
    section   => 'DEFAULT',
    param     => 'heat_metadata_server_url',
    value     => $controller_yoga::params::heat_metadata_server_url,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_waitcondition_server_url':
    conf_file => '/etc/heat/heat.conf',
    section   => 'DEFAULT',
    param     => 'heat_waitcondition_server_url',
    value     => $controller_yoga::params::heat_waitcondition_server_url,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_stack_domain_admin':
    conf_file => '/etc/heat/heat.conf',
    section   => 'DEFAULT',
    param     => 'stack_domain_admin',
    value     => $controller_yoga::params::heat_stack_domain_admin,
  }
   
  controller_yoga::configure_heat::do_config { 'heat_stack_domain_admin_password':
    conf_file => '/etc/heat/heat.conf',
    section   => 'DEFAULT',
    param     => 'stack_domain_admin_password',
    value     => $controller_yoga::params::heat_stack_domain_admin_password,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_stack_user_domain_name':
    conf_file => '/etc/heat/heat.conf',
    section   => 'DEFAULT',
    param     => 'stack_user_domain_name',
    value     => $controller_yoga::params::heat_stack_user_domain_name,
  }

  controller_yoga::configure_heat::do_config { 'heat_num_engine_workers':
    conf_file => '/etc/heat/heat.conf',
    section   => 'DEFAULT',
    param     => 'num_engine_workers',
    value     => $controller_yoga::params::heat_num_engine_workers,
  }

  controller_yoga::configure_heat::do_config { 'heat_workers':
    conf_file => '/etc/heat/heat.conf',
    section   => 'heat_api',
    param     => 'workers',
    value     => $controller_yoga::params::heat_workers,
  }

  controller_yoga::configure_heat::do_config { 'heat_db':
    conf_file => '/etc/heat/heat.conf',
    section   => 'database',
    param     => 'connection',
    value     => $controller_yoga::params::heat_db,
  }
  
# MS auth_uri deprecated. Use option "www_authenticate_uri"
#  controller_yoga::configure_heat::do_config { 'heat_auth_uri':
#    conf_file => '/etc/heat/heat.conf',
#    section   => 'keystone_authtoken',
#    param     => 'auth_uri',
#    value     => $controller_yoga::params::auth_uri,
#  }   
  controller_yoga::configure_heat::do_config { 'heat_auth_uri':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'www_authenticate_uri',
    value     => $controller_yoga::params::www_authenticate_uri,
  }   

  controller_yoga::configure_heat::do_config { 'heat_auth_url':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'auth_url',
    value     => $controller_yoga::params::auth_url,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_keystone_authtoken_memcached_servers':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'memcached_servers',
    value     => $controller_yoga::params::memcached_servers,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_auth_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'auth_type',
    value     => $controller_yoga::params::auth_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_project_domain_name':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'project_domain_name',
    value     => $controller_yoga::params::project_domain_name,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_user_domain_name':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'user_domain_name',
    value     => $controller_yoga::params::user_domain_name,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_project_name':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'project_name',
    value     => $controller_yoga::params::project_name,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_username':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'username',
    value     => $controller_yoga::params::heat_username,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_password':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'password',
    value     => $controller_yoga::params::heat_password,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_cafile':
    conf_file => '/etc/heat/heat.conf',
    section   => 'keystone_authtoken',
    param     => 'cafile',
    value     => $controller_yoga::params::cafile,
  }

  controller_yoga::configure_heat::do_config { 'heat_trustee_auth_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'trustee',
    param     => 'auth_type',
    value     => $controller_yoga::params::auth_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_trustee_auth_url':
    conf_file => '/etc/heat/heat.conf',
    section   => 'trustee',
    param     => 'auth_url',
    value     => $controller_yoga::params::auth_url,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_trustee_username':
    conf_file => '/etc/heat/heat.conf',
    section   => 'trustee',
    param     => 'username',
    value     => $controller_yoga::params::heat_username,
  }

  controller_yoga::configure_heat::do_config { 'heat_trustee_password':
    conf_file => '/etc/heat/heat.conf',
    section   => 'trustee',
    param     => 'password',
    value     => $controller_yoga::params::heat_password,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_trustee_user_domain_name':
    conf_file => '/etc/heat/heat.conf',
    section   => 'trustee',
    param     => 'user_domain_name',
    value     => $controller_yoga::params::user_domain_name,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_ec2authtoken_auth_uri':
    conf_file => '/etc/heat/heat.conf',
    section   => 'ec2authtoken',
    param     => 'auth_uri',
    value     => $controller_yoga::params::auth_uri,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_keystone_auth_uri':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_keystone',
    param     => 'auth_uri',
    value     => $controller_yoga::params::auth_uri,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_keystone_endpoint_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_keystone',
    param     => 'endpoint_type',
    value     => $controller_yoga::params::heat_endpoint_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_keystone_ca_file':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_keystone',
    param     => 'ca_file',
    value     => $controller_yoga::params::cafile,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_keystone_insecure':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_keystone',
    param     => 'insecure',
    value     => $controller_yoga::params::heat_insecure,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_neutron_endpoint_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_neutron',
    param     => 'endpoint_type',
    value     => $controller_yoga::params::heat_endpoint_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_neutron_ca_file':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_neutron',
    param     => 'ca_file',
    value     => $controller_yoga::params::cafile,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_neutron_insecure':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_neutron',
    param     => 'insecure',
    value     => $controller_yoga::params::heat_insecure,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_nova_endpoint_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_nova',
    param     => 'endpoint_type',
    value     => $controller_yoga::params::heat_endpoint_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_nova_ca_file':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_nova',
    param     => 'ca_file',
    value     => $controller_yoga::params::cafile,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_nova_insecure':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_nova',
    param     => 'insecure',
    value     => $controller_yoga::params::heat_insecure,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_cinder_endpoint_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_cinder',
    param     => 'endpoint_type',
    value     => $controller_yoga::params::heat_endpoint_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_cinder_ca_file':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_cinder',
    param     => 'ca_file',
    value     => $controller_yoga::params::cafile,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_cinder_insecure':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_cinder',
    param     => 'insecure',
    value     => $controller_yoga::params::heat_insecure,
  }   

  controller_yoga::configure_heat::do_config { 'heat_clients_glance_endpoint_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_glance',
    param     => 'endpoint_type',
    value     => $controller_yoga::params::heat_endpoint_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_glance_ca_file':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_glance',
    param     => 'ca_file',
    value     => $controller_yoga::params::cafile,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_glance_insecure':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_glance',
    param     => 'insecure',
    value     => $controller_yoga::params::heat_insecure,
  }
    
  controller_yoga::configure_heat::do_config { 'heat_clients_endpoint_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients',
    param     => 'endpoint_type',
    value     => $controller_yoga::params::heat_endpoint_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_ca_file':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients',
    param     => 'ca_file',
    value     => $controller_yoga::params::cafile,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_insecure':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients',
    param     => 'insecure',
    value     => $controller_yoga::params::heat_insecure,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_heat_endpoint_type':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_heat',
    param     => 'endpoint_type',
    value     => $controller_yoga::params::heat_endpoint_type,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_heat_ca_file':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_heat',
    param     => 'ca_file',
    value     => $controller_yoga::params::cafile,
  }
  
  controller_yoga::configure_heat::do_config { 'heat_clients_heat_insecure':
    conf_file => '/etc/heat/heat.conf',
    section   => 'clients_heat',
    param     => 'insecure',
    value     => $controller_yoga::params::heat_insecure,
  }   

#parametro per risolvere problema connessione endpoint https

  controller_yoga::configure_heat::do_config { 'heat_enable_proxy_headers_parsing':
    conf_file => '/etc/heat/heat.conf',
    section   => 'oslo_middleware',
    param     => 'enable_proxy_headers_parsing',
    value     => $controller_yoga::params::enable_proxy_headers_parsing,
  }

  controller_yoga::configure_heat::do_config { 'heat_rabbit_ha_queues':
    conf_file => '/etc/heat/heat.conf',
    section   => 'oslo_messaging_rabbit',
    param     => 'rabbit_ha_queues',
    value     => $controller_yoga::params::rabbit_ha_queues,
  }

  controller_yoga::configure_heat::do_config { 'heat_amqp_durable_queues':
    conf_file => '/etc/heat/heat.conf',
    section   => 'oslo_messaging_rabbit',
    param     => 'amqp_durable_queues',
    value     => $controller_yoga::params::amqp_durable_queues,
  }


       
}
