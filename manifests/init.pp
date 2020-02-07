class sudo (
  Boolean $config_file_replace = true,
  Boolean $selective_purge = false,
) {

  $_ignore = $selective_purge ? {
    true    => '*[!_puppet]',
    default => undef,
  }
  package {'sudo':
    ensure => 'present',
  }
  -> file {'/etc/sudoers':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0440',
  }
  -> file {'/etc/sudoers.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    purge   => true,
    recurse => true,
    force   => true,
    ignore  => $_ignore,
  }

  if $config_file_replace {
    File['/etc/sudoers'] { content => template('sudo/sudoers.erb'), }
  } else {
    augeas { 'includedirsudoers':
      changes => ['set /files/etc/sudoers/#includedir /etc/sudoers.d'],
      incl    => '/etc/sudoers',
      lens    => 'Sudoers.lns',
    }
  }

}
