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
# Copyright 2016 Ronen Narkis, unless otherwise noted.
#
class reprepro(
  $override='',
  $pub_key='',
  $pub_file='',
  $key_id=''
) {

  include ::reprepro::deployment
  package{'reprepro':
    ensure  => present
  }

  file{'/var/packages/ubuntu/conf/distributions':
    owner   => 'root',
    group   => 'root',
    content => template('reprepro/distributions.erb'),
  } -> Exec<| |>

  file{'/var/packages/ubuntu/conf/override.wily':
      source  => $override,
      require => File['/var/packages/ubuntu/conf/']
  } -> Exec<| |>

  if $pub_key != '' and $pub_file != '' {
    file{"/var/packages/ubuntu/${pub_key}":
      source => $pub_file
    }
  }
}
