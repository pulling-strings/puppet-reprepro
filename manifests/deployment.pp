# Deployment only folder structure
class reprepro::deployment {
  file{'/var/packages':
    ensure => directory,
  }

  file{['/var/packages/ubuntu/', '/var/packages/ubuntu/conf/',
          '/var/packages/ubuntu/debian/', '/var/packages/ubuntu/debian/conf/']:
    ensure  => directory,
    require => File['/var/packages']
  }
}
