class rvm::packages::redhat {
  $package_list = ['gcc-c++', 'patch', 'readline', 'readline-devel', 'zlib', 
                   'zlib-devel', 'libyaml-devel', 'libffi-devel', 
                   'openssl-devel', 'curl', 'make', 'bzip2']
                   
  # Virtualize Package list to prevent conflicts
  @package { $package_list:
    ensure => 'present',
    tag    => 'rvm-packages',
  }
  
  # Realize packages list. 
  each($package_list) |$package_name| {
    if ! defined(Package[$package_name]) {
      package { $package_name: ensure => latest; } }
  }
}
