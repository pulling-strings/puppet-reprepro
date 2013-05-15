# == Class: reprepro::includeb
#
# Signing and including package in reprepro
#
# === Parameters
#
# [*deb*]
#   The Deb file path to include
#
# [*package_name*]
#   The Deb package name
#
# [*private_key*]
#   Gpg private key file in case signing is used
#     and key isn't present (optional)
#
# === Examples
#
#  class{'reprepro::includeb':
#    deb          => '/vagrant/fpm-recipes/celestial/pkg/celestial_0.0.1+fpm0_all.deb',
#    package_name => 'celestial'
#  }
# === Authors
#
# Ronen Narkis <narkisr@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ronen Narkis, unless otherwise noted.
class reprepro::includeb($deb='', $package_name='', $private_key='') {

  $key_id = hiera('reprepro::key_id')

  package{'dpkg-sig':
    ensure  => present
  } ->

  exec{'gpg import private':
    command => "gpg --allow-secret-key-import --import ${private_key}",
    user    => 'root',
    path    => '/usr/bin',
    unless  => "/usr/bin/gpg --list-keys | /bin/grep ${key_id}"
  } ->

  exec{'sign deb':
    command => "dpkg-sig -k ${key_id} --sign builder ${deb}",
    user    => 'root',
    path    => '/usr/bin',
    unless  =>  "/usr/bin/dpkg-sig -l ${deb} | /bin/grep builder ",

  } ->

  exec{'import deb':
    command => "reprepro includedeb quantal ${deb}",
    cwd     =>  '/var/packages/ubuntu/',
    user    => 'root',
    path    => '/usr/bin/',
    unless  =>  "/usr/bin/reprepro list quantal | /bin/grep ${package_name}",
  }
}
