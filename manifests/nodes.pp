#Make sure all Ubuntu nodes have the webserver Lighttpd installed

node /ubuntu/ {
  include lighttpd
}

#Make sure all Centos nodes have Wordpress installed

node /centos/ {
  include wordpress
    firewall { '100 allow http':
    proto       => 'tcp',
    dport       => '80',
    action        => 'accept',
  }
}
