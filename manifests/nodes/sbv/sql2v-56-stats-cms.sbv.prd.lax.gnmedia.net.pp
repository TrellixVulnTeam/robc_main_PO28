node 'sql2v-56-stats-cms.sbv.prd.lax.gnmedia.net' {
    include base
    $project="springboard"
    class {"mysqld56": template=>"56-stats-cms.sbv.prd.lax-master"}

    # Allow mysql to use lots of files per client
    class {'security::mysql_nofile':
                hard_file_limit => 32768,
		soft_file_limit => 24576,
    }

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_stats_cms_sbv_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_stats_cms_sbv_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_prd_sql_log/sql2v-56-stats-cms.sbv.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
