class lighttpd::config {
    file { '/etc/lighttpd/lighttpd.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/lighttpd/lighttpd.conf',
        require => Class['lighttpd::install'],
        notify  => Class['lighttpd::service']
} }
