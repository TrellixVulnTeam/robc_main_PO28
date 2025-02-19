node 'app1v-dh.si.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project = "doublehelix"
        include common::app
        include doublehelix::fe_sites
	include doublehelix::commonconfig::stg
        #include doublehelix::nodejs


        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_shared/dh-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_log/app1v-dh.si.stg.lax.gnmedia.net",
        }
        common::nfsmount { "/app/tmp":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_tmp/app1v-dh.si.stg.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_ugc/dh-ugc",
        }

        cron { "paparazzo_tmp_cleaner":
            user        => "nobody",
            command     => "tmpwatch 1h /app/tmp/paparazzo",
            hour        => 1,
            minute      => 1,
        }

}
