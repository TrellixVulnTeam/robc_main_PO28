node 'app2v-wp.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include wordpresspb::appserver
    $project="atomiconline"
    $httpd="pbwordpress"

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/wp-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app2v-wp.ao.dev.lax.gnmedia.net",
    }

    common::ugcmount{ "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/wp-ugc",
    }

}
