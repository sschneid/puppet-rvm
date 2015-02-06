# Compliments of Toni Leino (Frodotus)
# # https://github.com/Frodotus/puppet-rvm/commit/17d854f20f0d49185938f84c4108823e9212c02a
define rvm::define::gem(
  $ruby_version,
  $gem_name         = $name,
  $ensure           = 'present',
  $gemset           = '',
  $gem_version      = '',
  $allow_prerelease = false
) {

  ## Set sensible defaults for Exec resource
  Exec {
    path => '/usr/local/rvm/bin:/bin:/sbin:/usr/bin:/usr/sbin',
  }

  # Local Parameters
  $rvm_path = '/usr/local/rvm'
  $rvm_ruby = "${rvm_path}/rubies"

  if $gemset == '' {
    $rvm_depency = "install-ruby-${ruby_version}"
    $rubyset_version = $ruby_version
  } else {
    $rvm_depency = "rvm-gemset-create-${gemset}-${ruby_version}"
    $rubyset_version = "${ruby_version}@${gemset}"
  }

  $prerelease = any2bool($allow_prerelease) ? {
    true  => '--prerelease',
    false => '',
  }

  # Setup proper install/uninstall commands based on gem version.
  if $gem_version == '' {
    $gem = {
      'install'   => "rvm ${rubyset_version} do gem install ${gem_name} ${prerelease} --no-ri --no-rdoc",
      'uninstall' => "rvm ${rubyset_version} do gem uninstall ${gem_name}",
      'lookup'    => "rvm ${rubyset_version} do gem list | grep ${gem_name}",
    }
  }
  else {
    $gem = {
      'install'   => "rvm ${rubyset_version} do gem install ${gem_name} ${prerelease} -v ${gem_version} --no-ri --no-rdoc",
      'uninstall' => "rvm ${rubyset_version} do gem uninstall ${gem_name} -v ${gem_version}",
      'lookup'    => "rvm ${rubyset_version} do gem list | grep ${gem_name} | grep ${gem_version}",
    }
  }


  ## Begin Logic
  if $ensure == 'present' {
    exec { "rvm-gem-install-${gem_name}-${gem_version}-${ruby_version}":
      command => $gem['install'],
      unless  => $gem['lookup'],
      require => [Class['rvm'], Exec[$rvm_depency]],
    }
  }
  elsif $ensure == 'absent' {
    exec { "rvm-gem-uninstall-${gem_name}-${gem_version}-${ruby_version}":
      command => $gem['uninstall'],
      onlyif  => $gem['lookup'],
      require => [Class['rvm'], Exec[$rvm_depency]],
    }
  }
}
