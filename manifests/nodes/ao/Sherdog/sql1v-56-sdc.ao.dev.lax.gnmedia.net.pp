node 'sql1v-56-sdc.ao.dev.lax.gnmedia.net' {
    $project='atomiconline'
    include base
    class {"mysqld56": template=>"56-sdc.ao.dev.lax-standalone", sqlclass=>"supported"}


    common::nfsmount { '/sql/log':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_sql_log/sql1v-56-sdc.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { '/sql/binlog':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_sdc_ao_dev_lax_binlog",
    }

    common::nfsmount { '/sql/data':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_sdc_ao_dev_lax_data",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
