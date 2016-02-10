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
# Copyright 2015 Ronen Narkis, unless otherwise noted.
class reprepro::nginx(
  $vhost = 'repo.local'
){

  include '::nginx'

  nginx::resource::location { 'conf':
    ensure              => present,
    location            => '~ /(.*)/conf',
    vhost               => $vhost,
    www_root            => '/var/packages',
    location_cfg_append => {'deny' => 'all'}
  }

  nginx::resource::location { 'db':
    ensure              => present,
    location            => '~ /(.*)/db',
    vhost               => $vhost,
    www_root            => '/var/packages',
    location_cfg_append => {'deny' => 'all'}
  }
}
