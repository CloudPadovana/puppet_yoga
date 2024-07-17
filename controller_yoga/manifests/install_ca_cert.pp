class controller_yoga::install_ca_cert inherits controller_yoga::params {

  yumrepo { "EGI-trustanchors":
          baseurl=> "http://repository.egi.eu/sw/production/cas/1/current/",
          descr=> "EGI Software Repository - REPO META (releaseId,repositoryId,repofileId) - (13352,-,2387)",
          enabled=> 1,
          gpgcheck=> 1,
          gpgkey=> 'http://repository.egi.eu/sw/production/cas/1/GPG-KEY-EUGridPMA-RPM-3',
  }

  $capackages = [ "ca-policy-egi-core",  "fetch-crl" ]
  package { $capackages:
    ensure  => "installed",
    require => YUMREPO[ "EGI-trustanchors" ],
  }

  # TODO remove old INFN CA certificate
  file {'INFN-CA.pem':
    source  => 'puppet:///modules/controller_yoga/INFN-CA.pem',
    path    => '/etc/grid-security/certificates/INFN-CA.pem',
  }

  # TODO check if keys are necessary
  file { 'cert_pem':
    path    => '/etc/grid-security/cert.pem',
    source  => '/etc/grid-security/hostcert.pem',
    ensure  => 'present',
    owner   => 'apache',
    group   => 'apache',
  }

  file { 'key_pem':
    path    => '/etc/grid-security/key.pem',
    source  => '/etc/grid-security/hostkey.pem',
    ensure  => 'present',
    owner   => 'apache',
    group   => 'apache'
  }

  if $facts['os']['name'] == 'AlmaLinux' {

    file { '/etc/pki/ca-trust/source/anchors/GEANT_OV_RSA_CA4.pem':
      source  => 'puppet:///modules/controller_yoga/GEANT_OV_RSA_CA4.pem',
      tag     => [ "ca_conf" ],
    }

    file { '/etc/pki/ca-trust/source/anchors/GEANTeScienceSSLCA4.pem':
      ensure  => link,
      target  => '/etc/grid-security/certificates/GEANTeScienceSSLCA4.pem',
      require => Package[ $capackages ],
      tag     => [ "ca_conf" ],
    }

    file { '/etc/pki/ca-trust/source/anchors/USERTrustRSACertificationAuthority.pem':
      ensure  => link,
      target  => '/etc/grid-security/certificates/USERTrustRSACertificationAuthority.pem',
      require => Package[ $capackages ],
      tag     => [ "ca_conf" ],
    }

    exec { 'update-ca-trust':
      command     => "/usr/bin/update-ca-trust extract",
      refreshonly => true,
    }

    File <| tag == 'ca_conf' |> ~> Exec[ "update-ca-trust" ]
  }
}
