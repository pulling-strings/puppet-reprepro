# == Class: reprepro::nginx
#
# Sets up reprepro nginx vhost and server
#
# === Examples
#
# class{'reprepro::nginx':}
#
# === Authors
#
# Ronen Narkis <narkisr@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ronen Narkis, unless otherwise noted.
class reprepro::nginx {

  class {'::nginx': }

  nginx::resource::vhost { 'repo.local':
    ensure   => present,
    www_root => '/var/packages',
  }

  nginx::resource::location { 'conf':
    ensure              => present,
    location            => '~ /(.*)/conf',
    vhost               => 'repo.local',
    www_root            => '/var/packages',
    location_cfg_append => {'deny' => 'all'},
  }

  nginx::resource::location { 'db':
    ensure              => present,
    location            => '~ /(.*)/db',
    vhost               => 'repo.local',
    www_root            => '/var/packages',
    location_cfg_append => {'deny' => 'all'}
  }

}
