node 'sql2v-56-dh.si.stg.lax.gnmedia.net' {
    include base
    $project="dh"
    class {"mysqld56": template=>"56-dh.si.stg.lax-master"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_dh_si_stg_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_dh_si_stg_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_sql_log/sql2v-56-dh.si.stg.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
