class hosts inherits hosts::params {
  file { '/etc/hosts':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("hosts/${::lsbdistcodename}/etc/hosts.erb"),
    notify  => Exec['network-restart'],
  }

  exec { 'network-restart':
      command     => '/etc/init.d/networking restart',
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      refreshonly => true,
  }
}