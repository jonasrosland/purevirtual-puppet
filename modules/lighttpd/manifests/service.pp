class lighttpd::service {
    service { 'lighttpd':
        ensure  => running,
        enable  => true,
        require => Class['lighttpd::install']
    }
}
