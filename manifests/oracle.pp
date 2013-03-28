node /database/ {

package { "glibc.i686":
        ensure => latest,
} 

package { "unzip":
        ensure => latest,
}

oradb::installdb{ '112010_Linux-x86-64':
        version      => '11.2.0.1', 
        file         => 'linux.x64_11gR2_database',
        databaseType => 'SE',
        oracleBase   => '/oracle',
        oracleHome   => '/oracle/product/11.2/db',
        user         => 'oracle',
        group        => 'dba',
        downloadDir  => '/install/',  
 }

 oradb::listener{'start listener':
        oracleBase   => '/oracle',
        oracleHome   => '/oracle/product/11.2/db',
        user         => 'oracle',
        group        => 'dba',
        action       => 'start',  
	require      => File["/oracle/product/11.2/db/bin/lsnrctl"],
 }

}
