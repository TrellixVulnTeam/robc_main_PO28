node 'sql1v-tb.ao.prd.lax.gnmedia.net' {
    $project='atomiconline'
    include base
    class {"mysqld56": template=>"56-tb.ao.prd.lax-master", sqlclass=>"supported"}


    common::nfsmount { '/sql/data':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_tb_ao_prd_lax_data",
    }

    common::nfsmount { '/sql/binlog':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_tb_ao_prd_lax_binlog",
    }

    common::nfsmount { '/sql/log':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_tb_ao_prd_lax_log",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
