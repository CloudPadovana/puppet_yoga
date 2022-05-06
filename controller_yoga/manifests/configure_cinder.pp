class controller_yoga::configure_cinder inherits controller_yoga::params {

#
# Questa classe:
# - popola il file /etc/cinder/cinder.conf
# - popola il file /etc/cinder/policy.yaml
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
                                                                                                                                             
  
# cinder.conf
       
   controller_yoga::configure_cinder::do_config { 'cinder_auth_strategy': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'auth_strategy', value => $controller_yoga::params::auth_strategy, }       
   controller_yoga::configure_cinder::do_config { 'cinder_my_ip': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'my_ip', value => $controller_yoga::params::cinder_my_ip, }       
   controller_yoga::configure_cinder::do_config { 'cinder_public_endpoint': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'public_endpoint', value => $controller_yoga::params::cinder_public_endpoint, }
   #MS iscsi_helper deprecated; replaced with target_helper    
   controller_yoga::configure_cinder::do_config { 'cinder_iscsi_helper': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'target_helper', value => $controller_yoga::params::cinder_iscsi_helper, }
   controller_yoga::configure_cinder::do_config { 'cinder_enabled_backends': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'enabled_backends', value => $controller_yoga::params::cinder_enabled_backends, }
   controller_yoga::configure_cinder::do_config { 'cinder_default_volume_type': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'default_volume_type', value => $controller_yoga::params::cinder_default_volume_type, }

  controller_yoga::configure_cinder::do_config { 'cinder_db': conf_file => '/etc/cinder/cinder.conf', section => 'database', param => 'connection', value => $controller_yoga::params::cinder_db, }
  controller_yoga::configure_cinder::do_config { 'cinder_transport_url': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'transport_url', value => $controller_yoga::params::transport_url, }
  controller_yoga::configure_cinder::do_config { 'cinder_osapi_volume_workers': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'osapi_volume_workers', value => $controller_yoga::params::cinder_osapi_volume_workers, }

   ## FF da queens cambiano le porte, /etc/cinder/cinder.conf [keystone_authtoken] auth_uri = http://controller:5000 e auth_url = http://controller:5000
   ## MS Anche per cinder dovrebbe essere auth_uri --> www_authenticate_uri
   controller_yoga::configure_cinder::do_config { 'cinder_www_authenticate_uri': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'www_authenticate_uri', value => $controller_yoga::params::www_authenticate_uri, }   
   controller_yoga::configure_cinder::do_config { 'cinder_auth_url': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'auth_url', value => $controller_yoga::params::cinder_keystone_authtoken_auth_url, }
   controller_yoga::configure_cinder::do_config { 'cinder_auth_type': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'auth_type', value => $controller_yoga::params::auth_type, }
   controller_yoga::configure_cinder::do_config { 'cinder_project_domain_name': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'project_domain_name', value => $controller_yoga::params::project_domain_name, }
   controller_yoga::configure_cinder::do_config { 'cinder_user_domain_name': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'user_domain_name', value => $controller_yoga::params::user_domain_name, }
   controller_yoga::configure_cinder::do_config { 'cinder_project_name': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'project_name', value => $controller_yoga::params::project_name, }
   controller_yoga::configure_cinder::do_config { 'cinder_username': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'username', value => $controller_yoga::params::cinder_username, }
   controller_yoga::configure_cinder::do_config { 'cinder_password': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'password', value => $controller_yoga::params::cinder_password, }
   controller_yoga::configure_cinder::do_config { 'cinder_cafile': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'cafile', value => $controller_yoga::params::cafile, }
   controller_yoga::configure_cinder::do_config { 'cinder_keystone_authtoken_memcached_servers': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'memcached_servers', value => $controller_yoga::params::memcached_servers, }

   controller_yoga::configure_cinder::do_config { 'cinder_lock_path': conf_file => '/etc/cinder/cinder.conf', section => 'oslo_concurrency', param => 'lock_path', value => $controller_yoga::params::cinder_lock_path, }

############# Ceph configuration
 controller_yoga::configure_cinder::do_config { 'cinder_ceph_volume_group': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'volume_group', value => $controller_yoga::params::ceph_volume_group, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph_volume_backend_name': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'volume_backend_name', value => $controller_yoga::params::ceph_volume_backend_name, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph_volume_driver': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'volume_driver', value => $controller_yoga::params::ceph_volume_driver, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph_rbd_pool': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_pool', value => $controller_yoga::params::cinder_ceph_rbd_pool, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph_rbd_ceph_conf': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_ceph_conf', value => $controller_yoga::params::ceph_rbd_ceph_conf, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph_rbd_flatten_volume_from_snapshot': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_flatten_volume_from_snapshot', value => $controller_yoga::params::ceph_rbd_flatten_volume_from_snapshot, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph_rbd_store_chunk_size': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_store_chunk_size', value => $controller_yoga::params::ceph_rbd_store_chunk_size, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph_rados_connect_timeout': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rados_connect_timeout', value => $controller_yoga::params::ceph_rados_connect_timeout, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph_rbd_max_clone_depth': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_max_clone_depth', value => $controller_yoga::params::ceph_rbd_max_clone_depth, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph_rbd_user': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_user', value => $controller_yoga::params::cinder_ceph_rbd_user, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph_rbd_secret_uuid': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_secret_uuid', value => $controller_yoga::params::cinder_ceph_rbd_secret_uuid, }
 # MS: Optimization that can be applied since the pool is used only for cinder      
  controller_yoga::configure_cinder::do_config { 'cinder_ceph_rbd_exclusive_cinder_pool': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_exclusive_cinder_pool', value => $controller_yoga::params::cinder_ceph_rbd_exclusive_cinder_pool, }

############# Ceph EC configuration

 controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_volume_group': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'volume_group', value => $controller_yoga::params::ceph_ec_volume_group, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_volume_backend_name': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'volume_backend_name', value => $controller_yoga::params::ceph_ec_volume_backend_name, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_volume_driver': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'volume_driver', value => $controller_yoga::params::ceph_volume_driver, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rbd_pool': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_pool', value => $controller_yoga::params::cinder_ceph_ec_rbd_pool, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rbd_ceph_conf': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_ceph_conf', value => $controller_yoga::params::ceph_rbd_ceph_ec_conf, }
   controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rbd_flatten_volume_from_snapshot': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_flatten_volume_from_snapshot', value => $controller_yoga::params::ceph_rbd_flatten_volume_from_snapshot, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rbd_store_chunk_size': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_store_chunk_size', value => $controller_yoga::params::ceph_rbd_store_chunk_size, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rados_connect_timeout': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rados_connect_timeout', value => $controller_yoga::params::ceph_rados_connect_timeout, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rbd_max_clone_depth': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_max_clone_depth', value => $controller_yoga::params::ceph_rbd_max_clone_depth, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rbd_user': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_user', value => $controller_yoga::params::cinder_ceph_rbd_user, }
  controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rbd_secret_uuid': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_secret_uuid', value => $controller_yoga::params::cinder_ceph_rbd_secret_uuid, }
 # MS: Optimization that can be applied since the pool is used only for cinder      
  controller_yoga::configure_cinder::do_config { 'cinder_ceph-ec_rbd_exclusive_cinder_pool': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_exclusive_cinder_pool', value => $controller_yoga::params::cinder_ceph_rbd_exclusive_cinder_pool, }



       
##########EqualLogic: e' stato definitivamente spendo 01/12/2021
#   controller_yoga::configure_cinder::do_config { 'cinder_eqlog_volume_group': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'volume_group', value => $controller_yoga::params::eqlog_volume_group, }
#   controller_yoga::configure_cinder::do_config { 'cinder_eqlog_volume_backend_name': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'volume_backend_name', value => $controller_yoga::params::eqlog_volume_backend_name, }
#   controller_yoga::configure_cinder::do_config { 'cinder_eqlog_volume_driver': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'volume_driver', value => $controller_yoga::params::eqlog_volume_driver, }
#   controller_yoga::configure_cinder::do_config { 'cinder_eqlog_san_ip': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'san_ip', value => $controller_yoga::params::eqlog_san_ip, }
#   controller_yoga::configure_cinder::do_config { 'cinder_eqlog_san_login': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'san_login', value => $controller_yoga::params::eqlog_san_login, }
#   controller_yoga::configure_cinder::do_config { 'cinder_eqlog_san_password': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'san_password', value => $controller_yoga::params::eqlog_san_password, }
#   controller_yoga::configure_cinder::do_config { 'cinder_eqlog_eqlx_group_name': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'eqlx_group_name', value => $controller_yoga::params::eqlog_eqlx_group_name, }
#   controller_yoga::configure_cinder::do_config { 'cinder_eqlog_eqlx_pool': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'eqlx_pool', value => $controller_yoga::params::eqlog_eqlx_pool, }

       
#######Proxy headers parsing
controller_yoga::configure_cinder::do_config { 'cinder_enable_proxy_headers_parsing': conf_file => '/etc/cinder/cinder.conf', section => 'oslo_middleware', param => 'enable_proxy_headers_parsing', value => $controller_yoga::params::enable_proxy_headers_parsing, }       
####################       

  controller_yoga::configure_cinder::do_config { 'cinder_rabbit_ha_queues': conf_file => '/etc/cinder/cinder.conf', section => 'oslo_messaging_rabbit', param => 'rabbit_ha_queues', value => $controller_yoga::params::rabbit_ha_queues, }
  controller_yoga::configure_cinder::do_config { 'cinder_amqp_durable_queues': conf_file => '/etc/cinder/cinder.conf', section => 'oslo_messaging_rabbit', param => 'amqp_durable_queues', value => $controller_yoga::params::amqp_durable_queues, }



       
# Settings needed for ceilometer (but we don't use anymore ceilometer)
#   controller_yoga::configure_cinder::do_config { 'cinder_notification_driver': conf_file => '/etc/cinder/cinder.conf', section => 'oslo_messaging_notifications', param => 'driver', value => $controller_yoga::params::cinder_notification_driver, }

#
# Sembra che i seguenti non servano piu`:
##   controller_yoga::configure_cinder::do_config { 'cinder_control_exchange': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'control_exchange', value => $controller_yoga::params::cinder_control_exchange, }
##   controller_yoga::configure_cinder::do_config { 'cinder_glusterfs_sparsed_volumes': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'glusterfs_sparsed_volumes', value => $controller_yoga::params::cinder_glusterfs_sparsed_volumes, }

#
#       
file {'cinder_policy.yaml':
             source      => 'puppet:///modules/controller_yoga/cinder_policy.yaml',
             path        => '/etc/cinder/policy.yaml',
             backup      => true,
             owner   => root,
             group   => cinder,
             mode    => "0640",
      }
       
}
