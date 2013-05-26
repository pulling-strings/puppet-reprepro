# == Class: reprepro::includeb
#
# Signing and including package in reprepro
#
# === Parameters
#
# [*deb*]
#   The Deb file path to include
#
# === Examples
#
#  reprepro::includeb { 'celestial':
#    deb => '/vagrant/fpm-recipes/celestial/pkg/celestial_0.0.1+fpm0_all.deb',
#  }
# === Authors
#
# Ronen Narkis <narkisr@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ronen Narkis, unless otherwise noted.
define reprepro::includeb($deb='') {

  $key_id = hiera('reprepro::key_id')

  if !defined(Package['dpkg-sig']) {
    package{'dpkg-sig':
      ensure  => present
    } -> Exec['gpg import private']
  }

  $private_key = hiera('reprepro::includeb::private_key')

  if !defined(Exec['gpg import private']) {
    exec{'gpg import private':
      command => "gpg --allow-secret-key-import --import ${private_key}",
      user    => 'root',
      path    => '/usr/bin',
      unless  => "/usr/bin/gpg --list-keys | /bin/grep ${key_id}"
    } -> Exec["sign ${deb}"]
  }

  exec{"sign ${deb}":
    command => "dpkg-sig -k ${key_id} --sign builder ${deb}",
    user    => 'root',
    path    => '/usr/bin',
    unless  =>  "/usr/bin/dpkg-sig -l ${deb} | /bin/grep builder ",
  } ->

  exec{"import ${deb}":
    command => "reprepro includedeb quantal ${deb}",
    cwd     =>  '/var/packages/ubuntu/',
    user    => 'root',
    path    => '/usr/bin/',
    unless  =>  "/usr/bin/reprepro list quantal | /bin/grep '${name}'",
  }
}
