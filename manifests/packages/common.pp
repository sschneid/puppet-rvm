class rvm::packages::common {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/rvm/bin',
  }
  
  exec { 'install-rvm':
    command => "curl -sSL https://get.rvm.io | bash -s stable",
    creates => '/usr/local/rvm/bin/rvm',
  }
  file { '/tmp/rvm':
    ensure  => absent,
    require => Exec['install-rvm'],
  }
}
