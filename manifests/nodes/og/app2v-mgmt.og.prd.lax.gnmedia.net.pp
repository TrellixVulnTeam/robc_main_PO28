node 'app2v-mgmt.og.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include origin::app_origin
    httpd::virtual_host {'management.originplatform.com': monitor => false }
    httpd::virtual_host {'support.originplatform.com': monitor => false }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_shared/origin-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_og_lax_prd_app_log/app2v-mgmt.og.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_ugc",
    }
}
