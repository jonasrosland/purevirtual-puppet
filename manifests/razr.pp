node puppet {
  class { 'sudo':
    config_file_replace => false,
  }
  include razor

#Include a DNS + DHCP server

 dnsmasq::conf { 'another-config':
   ensure => present,
   content => "dhcp-range=192.168.19.100,192.168.19.150,12h\ndhcp-boot=pxelinux.0\ndhcp-option=3,192.168.19.2\ndhcp-option=6,192.168.19.5\ndomain=purevirtual.lab\nexpand-hosts\ndhcp-host=puppet,192.168.19.5\nserver=8.8.8.8\n",
 }

#Create a Puppet broker to automatically deploy services after OS installation

 rz_broker { 'puppet_broker':
  ensure => present,
  plugin => 'puppet',
  metadata => { 
    broker_version => '2.7.18',
    server => 'puppet.purevirtual.lab',
  }
 }

#Install Ubuntu 12.04.1

rz_image { "ubuntu_precise_image":
  ensure  => present,
  type    => 'os', 
  version => '12.04.1',
  source  => "http://ftp.sunet.se/pub/os/Linux/distributions/ubuntu/ubuntu-cd/12.04.1/ubuntu-12.04.1-server-amd64.iso",
}

rz_model { 'install_ubuntu_precise':
  ensure => present,
  description => 'Ubuntu Precise',
  image => 'ubuntu_precise_image',
  metadata => {'domainname' => 'purevirtual.lab', 'hostname_prefix' => 'ubuntu-', 'root_password' => 'password'},
  template => 'ubuntu_precise',
}

rz_policy { 'ubuntu_precise_policy':
  ensure  => present,
  broker  => 'puppet_broker',
  model   => 'install_ubuntu_precise',
  enabled => 'false',
  tags    => ['memsize_1GiB'],
  template => 'linux_deploy',
  maximum => 10,
}

#Install Ubuntu 12.10

rz_image { "ubuntu_quantal_image":
  ensure  => present,
  type    => 'os', 
  version => '12.10',
  source  => "http://ftp.sunet.se/pub/os/Linux/distributions/ubuntu/ubuntu-cd/12.10/ubuntu-12.10-server-amd64.iso",
}

rz_model { 'install_ubuntu_quantal':
  ensure => present,
  description => 'Ubuntu Quantal',
  image => 'ubuntu_quantal_image',
  metadata => {'domainname' => 'purevirtual.lab', 'hostname_prefix' => 'ubuntu-', 'root_password' => 'password'},
  template => 'ubuntu_quantal',
}

rz_policy { 'ubuntu_quantal_policy':
  ensure  => present,
  broker  => 'puppet_broker',
  model   => 'install_ubuntu_quantal',
  enabled => 'true',
  tags    => ['memsize_1GiB'],
  template => 'linux_deploy',
  maximum => 10,
}

#Install CentOS 6.3

rz_image { "centos_6_3_image":
  ensure  => present,
  type    => 'os', 
  version => '6.3',
  source  => "http://ftp.sunet.se/pub/Linux/distributions/centos/6/isos/x86_64/CentOS-6.3-x86_64-minimal.iso",
}

rz_model { 'install_centos_6_3':
  ensure => present,
  description => 'Centos_6.3',
  image => 'centos_6_3_image',
  metadata => {'domainname' => 'purevirtual.lab', 'hostname_prefix' => 'centos-', 'root_password' => 'password'},
  template => 'centos_6',
}

rz_policy { 'centos_6_3_policy':
  ensure  => present,
  broker  => 'puppet_broker',
  model   => 'install_centos_6_3',
  enabled => 'true',
  tags    => ['memsize_2GiB'],
  template => 'linux_deploy',
  maximum => 10,
}

# Install an Oracle environment

rz_model { 'install_centos_6_3_oracle':
  ensure => present,
  description => 'Centos_6.3',
  image => 'centos_6_3_image',
  metadata => {'domainname' => 'purevirtual.lab', 'hostname_prefix' => 'database-', 'root_password' => 'password'},
  template => 'centos_6',
}

rz_policy { 'centos_6_3_policy_oracle':
  ensure  => present,
  broker  => 'puppet_broker',
  model   => 'install_centos_6_3_oracle',
  enabled => 'true',
  tags    => ['memsize_3GiB'],
  template => 'linux_deploy',
  maximum => 10,
}



    #Fully automated Hadoop installation
    # a tag to identify my <controller.hostname>
    rz_tag { "mac_eth0_of_the_namenode":
        tag_label   => "mac_eth0_of_the_namenode",
        tag_matcher => [ {
                        'key'     => 'mk_hw_nic0_serial',
                        'compare' => 'equal',
                        'value'   => "00:50:56:33:7d:56",
                    } ],
    }

    # a tag to identify my <compute?.hostname>
    rz_tag { "not_mac_eth0_of_the_namenode":
        tag_label   => "not_mac_eth0_of_the_namenode",
        tag_matcher => [ {
                        'key'     => 'mk_hw_nic0_serial',
                        'compare' => 'equal',
                        'value'   => "00:50:56:33:7d:56",
                        'inverse'  => "true",
                    } ],
    }

    rz_model { 'namenode_model':
      ensure      => present,
      description => 'NameNode CentOS Model',
      image       => 'ubuntu_precise_image',
      metadata    => {'domainname' => 'purevirtual.lab', 'hostname_prefix' => 'namenode', 'root_password' => 'password'},
      template    => 'ubuntu_precise',
    }

    rz_model { 'datanode_model':
      ensure      => present,
      description => 'DataNode CentOS Model',
      image       => 'ubuntu_precise_image',
      metadata    => {'domainname' => 'purevirtual.lab', 'hostname_prefix' => 'datanode', 'root_password' => 'password'},
      template    => 'ubuntu_precise',
    }

    rz_policy { 'namenode_policy':
      ensure  => present,
      broker  => 'puppet_broker',
      model   => 'namenode_model',
      enabled => 'true',
      tags    => ['mac_eth0_of_the_namenode', 'memsize_512MiB'],
      template => 'linux_deploy',
      maximum => 1,
    }    
    rz_policy { 'datanode_policy':
      ensure  => present,
      broker  => 'puppet_broker',
      model   => 'datanode_model',
      enabled => 'true',
      tags    => ['not_mac_eth0_of_the_namenode', 'memsize_512MiB', 'cpus_2'],
      template => 'linux_deploy',
      maximum => 3,
    }

}

