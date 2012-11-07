# Compliments of Toni Leino (Frodotus)
# https://github.com/Frodotus/puppet-rvm/commit/17d854f20f0d49185938f84c4108823e9212c02a
define rvm::define::gemset(
  $ensure = 'present',
  $ruby_version,
  $gemset_name
) {
  ## Set sensible defaults for Exec resource
  Exec {
    path    => '/usr/local/rvm/bin:/bin:/sbin:/usr/bin:/usr/sbin',
  }
  $rvm_source = "source /usr/local/rvm/scripts/rvm"
  if $ensure == 'present' {
    exec { "rvm-gemset-create-${gemset_name}-${ruby_version}":
      command => "bash -c '${rvm_source} ; rvm reset ; rvm use ${ruby_version}@${gemset_name} --create'",
      unless  => "bash -c '${rvm_source} ; rvm use ${ruby_version} ; rvm gemset list | grep ${gemset_name}'",
      require => [Class['rvm'], Exec["install-ruby-${ruby_version}"]],
    }
  } elsif $ensure == 'absent' {
    exec { "rvm-gemset-delete-${gemset_name}-${ruby_version}":
      command => "bash -c '${rvm_source} ; rvm reset ; use ${ruby_version} ;  rvm --force gemset delete ${gemset_name}'",
      onlyif  => "bash -c '${rvm_source} ; rvm use ${ruby_version} ; rvm gemset list | grep ${gemset_name}'",
      require => [Class['rvm'], Exec["install-ruby-${ruby_version}"]],
    }
  }
}
