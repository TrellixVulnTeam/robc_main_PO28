node 'uid1v-omiranda.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

############################################################################
    $project="atomiconline"
    $username="omiranda"
    include uidpb::devserver
    include uidpb::pbwb_uid_dbcred

    class {"mysqld56": template=>"56-default-uid",sqlclass=>"unsupported"}

############################################################################
##### Set up the sql server directory structures ###########################
############################################################################

        common::nfsmount { "/sql/data":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_omiranda_ao_dev_lax_sbx/sql/data",
        }

        common::nfsmount { "/sql/binlog":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_omiranda_ao_dev_lax_sbx/sql/binlog",
        }

        common::nfsmount { "/sql/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_omiranda_ao_dev_lax_sbx/sql/log",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_omiranda_ao_dev_lax_sbx/appshared",
        }

############################################################################

}
