node /namenode/ {
  include java, hosts
  class { 'hadoop':
    master => "namenode1.purevirtual.lab",
    slaves => ["datanode1.purevirtual.lab","datanode2.purevirtual.lab","datanode3.purevirtual.lab"]
  }
}

#Install Hadoop on a full cluster


node /datanode/ {
  include hadoop, java, hosts
  class { 'hadoop':
    master => "namenode1.purevirtual.lab",
    slaves => ["datanode1.purevirtual.lab","datanode2.purevirtual.lab","datanode3.purevirtual.lab"]
  }
}

