# == Class: reprepro
#
# A reprepro setup class
#
# === Parameters
#
# [*override*]
#   reprepro override file source
#
# [*pub_key*]
#   public key name that will be exposed by this repo http server (optional)
#
# [*pub_file*]
#   public key file source (optional)
#
# === Examples
#
#  class { reprepro:  }
#
# === Authors
#
# Ronen Narkis <narkisr@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ronen Narkis, unless otherwise noted.
#
class reprepro($override='', $pub_key='', $pub_file='') {

  package{'reprepro':
    ensure  => present
  }

  file{'/var/packages':
    ensure => directory,
  }

  file{['/var/packages/ubuntu/', '/var/packages/ubuntu/conf/',
          '/var/packages/ubuntu/debian/', '/var/packages/ubuntu/debian/conf/']:
    ensure  => directory,
    require => File['/var/packages']
  }

  $key_id = hiera('reprepro::key_id')

  file{'/var/packages/ubuntu/conf/distributions':
    owner      => 'root',
    group      => 'root',
    content    => template('reprepro/distributions.erb'),
  } -> Exec['import deb']

  file{'/var/packages/ubuntu/conf/override.quantal':
      source  => $override,
      require => File['/var/packages/ubuntu/conf/']
  } -> Exec['import deb']

  file{"/var/packages/ubuntu/${pub_key}":
    source => $pub_file
  }
}
