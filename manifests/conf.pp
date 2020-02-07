# Define: sudo::conf
#
# The target is to use https://github.com/saz/puppet-sudo module from were this
# definition was copied from instead of our.
#
# the $sudo_config_dir was removed, as we don't support it.
#
define sudo::conf(
  $ensure = present,
  $priority = 10,
  $content = undef,
  $source = undef,
) {

  # sudo skipping file names that contain a "."
  $tname = regsubst($name, '\.', '-', 'G')
  $dname = "${priority}_${tname}"

  include ::sudo

  $_dname = $sudo::selective_purge ? {
    true    => "${dname}_puppet",
    default => $dname
  }

  $notify = $ensure ? {
    'present' => Exec["sudo-syntax-check for file ${_dname}"],
    default   => undef,
  }

  file {"/etc/sudoers.d/${_dname}":
    ensure  => $ensure,
    owner   => root,
    group   => root,
    mode    => '0440',
    content => $content,
    source  => $source,
    notify  => $notify,
    require => Package['sudo'],
  }

  exec {"sudo-syntax-check for file ${_dname}":
    path        => $::path,
    command     => "visudo -c -f '/etc/sudoers.d/${_dname}' || ( rm -f '/etc/sudoers.d/${_dname}' && exit 1)",
    refreshonly => true,
  }

}
