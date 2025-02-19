node 'app1v-carbon.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app
        include carbon

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-carbon.tp.prd.lax.gnmedia.net",
  }

  common::nfsmount { "/app/data":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_data/carbon",
  }
}

