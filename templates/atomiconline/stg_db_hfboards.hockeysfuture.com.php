<?php
// #### This file is managed by Puppet, do not modify it directly.


//Database Master Config
$config['db']['host'] = 'vip-sqlrw-xf-hfb.ao.stg.lax.gnmedia.net';
$config['db']['port'] = '3306';
$config['db']['username'] = 'forums_hfb_w';
$config['db']['password'] = '<%= stgpbxf_forums_hfbrw %>';
$config['db']['dbname'] = 'forums_hfb';


//Database Slave config
$config['db']['adapterNamespace'] = 'DigitalPoint';
$GLOBALS['digitalPoint']['SlaveServerAll'][] = 'vip-sqlro-xf-hfb.ao.stg.lax.gnmedia.net';
$GLOBALS['digitalPoint']['SlaveUsername'] = 'forums_hfb_r';
$GLOBALS['digitalPoint']['SlavePassword'] = '<%= stgpbxf_forums_hfbro %>';
$GLOBALS['digitalPoint']['SlaveDBname']   = 'forums_hfb';
$GLOBALS['digitalPoint']['SlaveDBPort']   = '3306';


//CDN-Akamai Config
$config['externalDataUrl'] = 'http://cdn1-stg.hfboards.hockeysfuture.com/data';
$config['javaScriptUrl'] = 'http://cdn1-stg.hfboards.hockeysfuture.com/js';


//Memcache settings
$config['cache']['enabled'] = true;
$config['cache']['backend'] = 'Memcached';
$config['cache']['cacheSessions'] = true;
$config['cache']['backendOptions'] = array(
                'compression' => false,
                'servers' => array(
                                array(
                                                'host' => 'mem1v-xf-hfb.ao.stg.lax.gnmedia.net',
                                                'port' => 11211
                                ),
                                array(
                                                'host' => 'mem2v-xf-hfb.ao.stg.lax.gnmedia.net',
                                                'port' => 11211
                                )
                )
);

