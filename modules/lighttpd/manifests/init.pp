class lighttpd {
    include lighttpd::install, lighttpd::config, lighttpd::service, lighttpd::indexfile
}
