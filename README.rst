==================
Sudo Puppet module
==================

The definition `sudo::directive` provides a simple way to write sudo configurations parts.

------------------
Use
------------------

`directive`s are blocks of literal text as you would write to sudoers.

If you have a class of users named `users::virtual` and a virtual Group named `admin`:

::

  class example {
    include sudo
    include users::virtual

    realize(Group['admin'])

    sudo::directive {'admin_users':
      ensure  => present,
      content => "%admin ALL=(ALL) ALL",
      require => Group['admin'],
    }
  }


------------------
Parameters
------------------

Parameters to the main sudo class

config_file_replace
  Defaults to true. If true then `/etc/sudoers` file will be purged. If false then
  only a `#include` line will be added to existing `/etc/sudoers`

selective_purge
  Defautls to false. If false then all non puppet maintained files in `/etc/sudoers.d` will be purged.
  If true then files created by puppet in /etc/sudoers.d will be suffixed with `_puppet`. Only
  files ending in `_puppet` will be purged if not configured. Note there is no sensible
  way to migrate from selective_purge false to true without manual clean up of old files.


------------------
About
------------------

This module is provided to you by Camptocamp_.

.. _Camptocamp: http://www.camptocamp.com/

For more information about sudo see http://www.gratisoft.us/sudo/

