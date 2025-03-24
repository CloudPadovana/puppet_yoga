class compute_yoga::nova inherits compute_yoga::params {
#($compute_yoga::params::cloud_role) inherits compute_yoga::params {

#include compute_yoga::params
include compute_yoga::install

# $novapackages = [ "openstack-nova-compute",
#                     "openstack-nova-common" ]
# package { $novapackages: ensure => "installed" }



     file { '/etc/nova/nova.conf':
               ensure   => present,
               require    => Package["openstack-nova-common"],
          }


#     file { '/etc/nova/policy.json':
#               source      => 'puppet:///modules/compute_yoga/policy.json',
#               path        => '/etc/nova/policy.json',
#               backup      => true,
#          }
 

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

define do_augeas_config ($conf_file, $section, $param) {
    $split = split($name, '~')
    $value = $split[-1]
    $index = $split[-2]

    augeas { "augeas/${conf_file}/${section}/${param}/${index}/${name}":
          lens    => "PythonPaste.lns",
          incl    => $conf_file,
          changes => [ "set ${section}/${param}[${index}] ${value}" ],
          onlyif  => "get ${section}/${param}[${index}] != ${value}"
        }
}


define do_config_list ($conf_file, $section, $param, $values) {
    $values_size = size($values)

    # remove the entire block if the size doesn't match
    augeas { "remove_${conf_file}_${section}_${param}":
          lens    => "PythonPaste.lns",
          incl    => $conf_file,
          changes => [ "rm ${section}/${param}" ],
          onlyif  => "match ${section}/${param} size > ${values_size}"
    }

    $namevars = array_to_namevars($values, "${conf_file}~${section}~${param}", "~")

    # check each value
    compute_yoga::nova::do_augeas_config { $namevars:
             conf_file => $conf_file,
             section => $section,
             param => $param
    }
}

        
#
# nova.conf
#

  compute_yoga::nova::do_config { 'nova_enabled_apis': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'enabled_apis', value => $compute_yoga::params::nova_enabled_apis, }
  compute_yoga::nova::do_config { 'nova_transport_url': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'transport_url', value => $compute_yoga::params::transport_url, }

  compute_yoga::nova::do_config { 'nova_use_neutron': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'use_neutron', value => $compute_yoga::params::nova_use_neutron}
  compute_yoga::nova::do_config { 'nova_my_ip': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'my_ip', value => $compute_yoga::params::my_ip, }
  compute_yoga::nova::do_config { 'nova_firewall_driver': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'firewall_driver', value => $compute_yoga::params::nova_firewall_driver, }

  compute_yoga::nova::do_config { 'nova_cpu_allocation_ratio': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'cpu_allocation_ratio', value => $compute_yoga::params::cpu_allocation_ratio, }
  compute_yoga::nova::do_config { 'nova_ram_allocation_ratio': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'ram_allocation_ratio', value => $compute_yoga::params::ram_allocation_ratio, }
  compute_yoga::nova::do_config { 'nova_disk_allocation_ratio': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'disk_allocation_ratio', value => $compute_yoga::params::disk_allocation_ratio, }
  compute_yoga::nova::do_config { 'nova_allow_resize': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'allow_resize_to_same_host', value => $compute_yoga::params::allow_resize, }
  ### FF in xena deve essere esplicitato il compute_driver
  compute_yoga::nova::do_config { 'nova_compute_driver': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'compute_driver', value => $compute_yoga::params::nova_compute_driver, }

  ## MS se non si specifica log_dir, logga in syslog
compute_yoga::nova::do_config { 'nova_log_dir': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'log_dir', value => $compute_yoga::params::nova_log_dir, }
  ## MS se non si specifica state_path, usa /usr/lib/python3.6/site-packages
compute_yoga::nova::do_config { 'nova_state_path': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'state_path', value => $compute_yoga::params::nova_state_path, }

  compute_yoga::nova::do_config { 'nova_auth_type': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'auth_type', value => $compute_yoga::params::auth_type}
  compute_yoga::nova::do_config { 'nova_project_domain_name': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'project_domain_name', value => $compute_yoga::params::project_domain_name, }
  compute_yoga::nova::do_config { 'nova_user_domain_name': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'user_domain_name', value => $compute_yoga::params::user_domain_name, }
  compute_yoga::nova::do_config { 'nova_keystone_authtoken_auth_url': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'auth_url', value => $compute_yoga::params::nova_keystone_authtoken_auth_url, }
  compute_yoga::nova::do_config { 'nova_keystone_authtoken_memcached_servers': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'memcached_servers', value => $compute_yoga::params::memcached_servers, }
  compute_yoga::nova::do_config { 'nova_project_name': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'project_name', value => $compute_yoga::params::project_name, }
  compute_yoga::nova::do_config { 'nova_username': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'username', value => $compute_yoga::params::nova_username, }
  compute_yoga::nova::do_config { 'nova_password': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'password', value => $compute_yoga::params::nova_password, }
  compute_yoga::nova::do_config { 'nova_cafile': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'cafile', value => $compute_yoga::params::cafile, }



  compute_yoga::nova::do_config { 'nova_service_user_auth_type': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'auth_type', value => $compute_yoga::params::auth_type}
  compute_yoga::nova::do_config { 'nova_service_user_project_domain_name': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'project_domain_name', value => $compute_yoga::params::project_domain_name, }
  compute_yoga::nova::do_config { 'nova_service_user_user_domain_name': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'user_domain_name', value => $compute_yoga::params::user_domain_name, }
  compute_yoga::nova::do_config { 'nova_service_user_auth_url': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'auth_url', value => $compute_yoga::params::nova_keystone_authtoken_auth_url, }
  compute_yoga::nova::do_config { 'nova_service_user_project_name': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'project_name', value => $compute_yoga::params::project_name, }
  compute_yoga::nova::do_config { 'nova_service_user_username': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'username', value => $compute_yoga::params::nova_username, }
  compute_yoga::nova::do_config { 'nova_service_user_password': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'password', value => $compute_yoga::params::nova_password, }
  compute_yoga::nova::do_config { 'nova_service_user_cafile': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'cafile', value => $compute_yoga::params::cafile, }
  compute_yoga::nova::do_config { 'nova_service_user_send_service_user_token': conf_file => '/etc/nova/nova.conf', section => 'service_user', param => 'send_service_user_token', value => $compute_yoga::params::send_service_user_token, }




  compute_yoga::nova::do_config { 'nova_vnc_enabled': conf_file => '/etc/nova/nova.conf', section => 'vnc', param => 'enabled', value => $compute_yoga::params::vnc_enabled, }
  compute_yoga::nova::do_config { 'nova_vnc_server_listen': conf_file => '/etc/nova/nova.conf', section => 'vnc', param => 'server_listen', value => $compute_yoga::params::vnc_server_listen, }
  compute_yoga::nova::do_config { 'nova_vnc_server_proxyclient_address': conf_file => '/etc/nova/nova.conf', section => 'vnc', param => 'server_proxyclient_address', value => $compute_yoga::params::my_ip, }
  compute_yoga::nova::do_config { 'nova_novncproxy': conf_file => '/etc/nova/nova.conf', section => 'vnc', param => 'novncproxy_base_url', value => $compute_yoga::params::novncproxy_base_url, }

  compute_yoga::nova::do_config { 'nova_lock_path': conf_file => '/etc/nova/nova.conf', section => 'oslo_concurrency', param => 'lock_path', value => $compute_yoga::params::nova_lock_path, }
  compute_yoga::nova::do_config { 'nova_placement_region_name': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'region_name', value => $compute_yoga::params::region_name, }
  compute_yoga::nova::do_config { 'nova_placement_project_domain_name': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'project_domain_name', value => $compute_yoga::params::project_domain_name, }
  compute_yoga::nova::do_config { 'nova_placement_project_name': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'project_name', value => $compute_yoga::params::project_name, }
  compute_yoga::nova::do_config { 'nova_placement_auth_type': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'auth_type', value => $compute_yoga::params::auth_type, }
  compute_yoga::nova::do_config { 'nova_placement_user_domain_name': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'user_domain_name', value => $compute_yoga::params::user_domain_name, }
  compute_yoga::nova::do_config { 'nova_placement_auth_url': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'auth_url', value => $compute_yoga::params::nova_placement_auth_url, }
  compute_yoga::nova::do_config { 'nova_placement_username': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'username', value => $compute_yoga::params::placement_username, }
  compute_yoga::nova::do_config { 'nova_placement_password': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'password', value => $compute_yoga::params::placement_password, }
  compute_yoga::nova::do_config { 'nova_placement_cafile': conf_file => '/etc/nova/nova.conf', section => 'placement', param => 'cafile', value => $compute_yoga::params::cafile, }
  compute_yoga::nova::do_config { 'nova_neutron_auth_url': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'auth_url', value => $compute_yoga::params::neutron_auth_url, }
  compute_yoga::nova::do_config { 'nova_neutron_auth_type': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'auth_type', value => $compute_yoga::params::auth_type, }
  compute_yoga::nova::do_config { 'nova_neutron_project_domain_name': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'project_domain_name', value => $compute_yoga::params::project_domain_name, }
  compute_yoga::nova::do_config { 'nova_neutron_user_domain_name': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'user_domain_name', value => $compute_yoga::params::user_domain_name, }
  compute_yoga::nova::do_config { 'nova_neutron_region_name': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'region_name', value => $compute_yoga::params::region_name, }
  compute_yoga::nova::do_config { 'nova_neutron_project_name': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'project_name', value => $compute_yoga::params::project_name, }
  compute_yoga::nova::do_config { 'nova_neutron_username': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'username', value => $compute_yoga::params::neutron_username, }
  compute_yoga::nova::do_config { 'nova_neutron_password': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'password', value => $compute_yoga::params::neutron_password, }
  compute_yoga::nova::do_config { 'nova_neutron_endpoint_override': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'endpoint_override', value => $compute_yoga::params::neutron_endpoint_override, }
  compute_yoga::nova::do_config { 'nova_neutron_cafile': conf_file => '/etc/nova/nova.conf', section => 'neutron', param => 'cafile', value => $compute_yoga::params::cafile, }
  compute_yoga::nova::do_config { 'nova_libvirt_inject_pass': conf_file => '/etc/nova/nova.conf', section => 'libvirt', param => 'inject_password', value => $compute_yoga::params::libvirt_inject_pass, }
  compute_yoga::nova::do_config { 'nova_libvirt_inject_key': conf_file => '/etc/nova/nova.conf', section => 'libvirt', param => 'inject_key', value => $compute_yoga::params::libvirt_inject_key, }
  compute_yoga::nova::do_config { 'nova_libvirt_inject_part': conf_file => '/etc/nova/nova.conf', section => 'libvirt', param => 'inject_partition', value => $compute_yoga::params::libvirt_inject_part, }

  # IN QUEENS on AArch64 architecture cpu_mode for libvirt is set to host-passthrough by default ### 
  compute_yoga::nova::do_config { 'nova_libvirt_cpu_mode': conf_file => '/etc/nova/nova.conf', section => 'libvirt', param => 'cpu_mode', value => $compute_yoga::params::libvirt_cpu_mode, }

####config di libvirt per utilizzare ceph
  compute_yoga::nova::do_config { 'nova_libvirt_rbd_user': conf_file => '/etc/nova/nova.conf', section => 'libvirt', param => 'rbd_user', value => $compute_yoga::params::libvirt_rbd_user, }
  compute_yoga::nova::do_config { 'nova_libvirt_rbd_secret_uuid': conf_file => '/etc/nova/nova.conf', section => 'libvirt', param => 'rbd_secret_uuid', value => $compute_yoga::params::libvirt_rbd_secret_uuid, }

  compute_yoga::nova::do_config { 'nova_cinder_ssl_ca_file': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'ssl_ca_file', value => $compute_yoga::params::cafile, }
  compute_yoga::nova::do_config { 'nova_cinder_cafile': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'cafile', value => $compute_yoga::params::cafile, }
  compute_yoga::nova::do_config { 'nova_cinder_endpoint_template': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'endpoint_template', value => $compute_yoga::params::endpoint_template, }
  compute_yoga::nova::do_config { 'nova_cinder_os_region_name': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'os_region_name', value => $compute_yoga::params::region_name, }
  compute_yoga::nova::do_config { 'nova_cinder_auth_url': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'auth_url', value => $compute_yoga::params::cinder_keystone_auth_url, }
  compute_yoga::nova::do_config { 'nova_cinder_auth_type': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'auth_type', value => $compute_yoga::params::auth_type, }
  compute_yoga::nova::do_config { 'nova_cinder_project_domain_name': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'project_domain_name', value => $compute_yoga::params::project_domain_name, }
  compute_yoga::nova::do_config { 'nova_cinder_user_domain_name': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'user_domain_name', value => $compute_yoga::params::user_domain_name, }
  compute_yoga::nova::do_config { 'nova_cinder_region_name': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'region_name', value => $compute_yoga::params::region_name, }
  compute_yoga::nova::do_config { 'nova_cinder_project_name': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'project_name', value => $compute_yoga::params::project_name, }
  compute_yoga::nova::do_config { 'nova_cinder_username': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'username', value => $compute_yoga::params::cinder_username, }
  compute_yoga::nova::do_config { 'nova_cinder_password': conf_file => '/etc/nova/nova.conf', section => 'cinder', param => 'password', value => $compute_yoga::params::cinder_password, }

# Necessario per update da versione n a versione n+m (non m>1)
  compute_yoga::nova::do_config { 'nova_disable_compute_service_check_for_ffu': conf_file => '/etc/nova/nova.conf', section => 'workarounds', param => 'disable_compute_service_check_for_ffu', value => $compute_yoga::params::nova_disable_compute_service_check_for_ffu, }


#### per https nel compute non dovrebbe servire
compute_yoga::nova::do_config { 'nova_enable_proxy_headers_parsing': conf_file => '/etc/nova/nova.conf', section => 'oslo_middleware', param => 'enable_proxy_headers_parsing', value => $compute_yoga::params::enable_proxy_headers_parsing, }

######
#
# nova.conf for Ceilometer
#
  compute_yoga::nova::do_config { 'nova_instance_usage_audit': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'instance_usage_audit', value => $compute_yoga::params::nova_instance_usage_audit, }
  compute_yoga::nova::do_config { 'nova_instance_usage_audit_period': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'instance_usage_audit_period', value => $compute_yoga::params::nova_instance_usage_audit_period, }

# We don't use anymore ceilometer              
#              compute_yoga::nova::do_config { 'nova_notify_on_state_change': conf_file => '/etc/nova/nova.conf', section => 'notifications', param => 'notify_on_state_change', value => $compute_yoga::params::nova_notify_on_state_change, }
#  compute_yoga::nova::do_config { 'nova_notification_driver': conf_file => '/etc/nova/nova.conf', section => 'oslo_messaging_notifications', param => 'driver', value => $compute_yoga::params::nova_notification_driver, }


   compute_yoga::nova::do_config { "nova_amqp_durable_queues":
           conf_file => '/etc/nova/nova.conf',
           section   => 'oslo_messaging_rabbit',
           param     => 'amqp_durable_queues',
           value    => $compute_yoga::params::amqp_durable_queues,
         }

   compute_yoga::nova::do_config { "nova_rabbit_ha_queues":
           conf_file => '/etc/nova/nova.conf',
           section   => 'oslo_messaging_rabbit',
           param     => 'rabbit_ha_queues',
           value    => $compute_yoga::params::rabbit_ha_queues, 
         }

   compute_yoga::nova::do_config { "nova_heartbeat_in_pthread":
           conf_file => '/etc/nova/nova.conf',
           section   => 'oslo_messaging_rabbit',
           param     => 'heartbeat_in_pthread',
           value    => $compute_yoga::params::nova_heartbeat_in_pthread,
         }


# GPU specific setting and some setting for better performance for SSD disk for cld-dfa-gpu-01
 if ($::mgmtnw_ip == "192.168.60.107") {
  compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

compute_yoga::nova::do_config { 'pci_device_spec': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'device_spec', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_titanxp_VGA", "$compute_yoga::params::pci_titanxp_SND", "$compute_yoga::params::pci_quadro_VGA", "$compute_yoga::params::pci_quadro_Audio", "$compute_yoga::params::pci_quadro_USB", "$compute_yoga::params::pci_quadro_SerialBus", "$compute_yoga::params::pci_geforcegtx_VGA", "$compute_yoga::params::pci_geforcegtx_SND"  ],
           #values    => [ "$compute_yoga::params::pci_alias_1", "$compute_yoga::params::pci_alias_2" ],          
         }

   compute_yoga::nova::do_config_list { "preallocate_images":
           conf_file => '/etc/nova/nova.conf',
           section   => 'DEFAULT',
           param     => 'preallocate_images',
           values    => [ "$compute_yoga::params::nova_preallocate_images"   ],
         }
         
   
}

# GPU specific setting and some setting for better performance for SSD disk for cld-dfa-gpu-02 AND cld-np-gpu-02
 if ($::mgmtnw_ip == "192.168.60.108") or ($::mgmtnw_ip == "192.168.60.133") {
  compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_t4"   ],
         }

   compute_yoga::nova::do_config_list { "preallocate_images":
           conf_file => '/etc/nova/nova.conf',
           section   => 'DEFAULT',
           param     => 'preallocate_images',
           values    => [ "$compute_yoga::params::nova_preallocate_images"   ],
         }
         
   
}

# GPU specific setting and some setting for better performance for SSD disk for cld-np-gpu-03

if ($::mgmtnw_ip == "192.168.60.134") {

compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_A30" ],
         }


}



# GPU specific settings for cld-np-gpu-04

if ($::mgmtnw_ip == "192.168.60.136") {

compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_A2" ],
         }

   compute_yoga::nova::do_config_list { "pci_device_spec":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'device_spec',
           values    => [ "$compute_yoga::params::pci_device_spec_A2" ],
         }



}



# GPU specific setting and some setting for better performance for SSD disk for cld-dfa-gpu-03
 if ($::mgmtnw_ip == "192.168.60.83") {
  compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_A4000_VGA", "$compute_yoga::params::pci_A4000_SND" ],
         }

   compute_yoga::nova::do_config_list { "preallocate_images":
           conf_file => '/etc/nova/nova.conf',
           section   => 'DEFAULT',
           param     => 'preallocate_images',
           values    => [ "$compute_yoga::params::nova_preallocate_images"   ],
         }


}


# GPU specific settings for cld-dfa-gpu-04

if ($::mgmtnw_ip == "192.168.60.215") {

compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_A2" ],
         }


}



# GPU specific settings for cld-dfa-gpu-05

if ($::mgmtnw_ip == "192.168.60.109") {

compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_A30" ],
         }


}

# GPU specific settings for cld-ter-gpu-06

if ($::mgmtnw_ip == "192.168.60.170") {

compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_H100" ],
         }

   compute_yoga::nova::do_config_list { "pci_device_spec":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'device_spec',
           values    => [ "$compute_yoga::params::pci_device_spec_h100" ],
         }



}




# GPU specific settings for cld-dfa-gpu-06

if ($::mgmtnw_ip == "192.168.60.110") {

compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_L40S" ],
         }

   compute_yoga::nova::do_config_list { "pci_device_spec":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'device_spec',
           values    => [ "$compute_yoga::params::pci_device_spec_L40S" ],
         }



}



# GPU specific settings for cld-elx-gpu-01..02

 if ($::mgmtnw_ip == "192.168.60.190") or ($::mgmtnw_ip == "192.168.60.191") {

compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_A40" ],
         }

   compute_yoga::nova::do_config_list { "pci_device_spec":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'device_spec',
           values    => [ "$compute_yoga::params::pci_device_spec_A40" ],
         }


}




# GPU specific setting and some setting for better performance for SSD disk for cld-np-gpu-01 
 if ($::mgmtnw_ip == "192.168.60.128") {
  compute_yoga::nova::do_config { 'pci_passthrough_whitelist': conf_file => '/etc/nova/nova.conf', section => 'pci', param => 'passthrough_whitelist', value => $compute_yoga::params::pci_passthrough_whitelist, }

   compute_yoga::nova::do_config_list { "pci_alias":
           conf_file => '/etc/nova/nova.conf',
           section   => 'pci',
           param     => 'alias',
           values    => [ "$compute_yoga::params::pci_v100"   ],
         }

   compute_yoga::nova::do_config_list { "preallocate_images":
           conf_file => '/etc/nova/nova.conf',
           section   => 'DEFAULT',
           param     => 'preallocate_images',
           values    => [ "$compute_yoga::params::nova_preallocate_images"   ],
         }
         
   
}



#####
# Config libvirt access role
#####

  file { '49-org.libvirt.unix.manager.rules':
           source      => 'puppet:///modules/compute_yoga/49-org.libvirt.unix.manager.rules',
           path        => '/etc/polkit-1/rules.d/49-org.libvirt.unix.manager.rules',
           ensure      => present,
           backup      => true,
           owner   => root,
           group   => root,
           mode    => "0644",
  }

}
