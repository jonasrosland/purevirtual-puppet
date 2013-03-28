class lighttpd::install {
    package { 'lighttpd':
        ensure => installed
    }
}
