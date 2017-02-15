if $ipaddress_enp0s8 { $ipaddr = $ipaddress_enp0s8 }
else { $ipaddr = $ipaddress }
class {'openiosds':}
openiosds::namespace {'OPENIO':
  ns             => 'OPENIO',
  conscience_url => "${ipaddr}:6000",
  oioproxy_url   => "${ipaddr}:6006",
  eventagent_url => "beanstalk://${ipaddr}:6014",
  zookeeper_url  => "${ipaddr}:6005",
  ecd_url        => "${ipaddr}:6017",
}
openiosds::zookeeper {'zookeeper-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6005',
  bootstrap => true,
}
openiosds::account {'account-1':
  num        => '1',
  ns         => 'OPENIO',
  ipaddress  => $ipaddr,
  port       => '6009',
  redis_host => $ipaddr,
  redis_port => '6011',
}
openiosds::conscience {'conscience-1':
  num                   => '1',
  ns                    => 'OPENIO',
  ipaddress             => $ipaddr,
  port                  => '6000',
  service_update_policy => {'meta2'=>'KEEP|3|1|','sqlx'=>'KEEP|3|1|','rdir'=>'KEEP|1|1|user_is_a_service=rawx'},
  storage_policy        => 'UNSAFETHREECOPIES',
  storage_policies      => {'SINGLE'=>'NONE:NONE','TWOCOPIES'=>'NONE:DUPONETWO','THREECOPIES'=>'NONE:DUPONETHREE','ERASURECODE'=>'NONE:ERASURECODE','UNSAFETHREECOPIES'=>'UNSAFETHREECOPIES:DUPZEROTHREE'},
  data_security         => {'DUPONETWO'=>'plain/distance=1,nb_copy=2','DUPONETHREE'=>'plain/distance=1,nb_copy=3','ERASURECODE'=>'ec/k=6,m=3,algo=liberasurecode_rs_vand,distance=1','DUPZEROTHREE'=>'plain/distance=0,nb_copy=3'},
  pools                 => {'UNSAFETHREECOPIES'=>{'targets'=>'3,rawx','mask'=>'FFFFFFFFFFFFFFFF'}},
}
openiosds::meta0 {'meta0-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6001',
  location  => 'openio1',
}
openiosds::meta0 {'meta0-2':
  num       => '2',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6071',
  location  => 'openio2',
}
openiosds::meta0 {'meta0-3':
  num       => '3',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6081',
  location  => 'openio3',
}
openiosds::meta1 {'meta1-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6002',
}
openiosds::meta1 {'meta1-2':
  num       => '2',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6072',
  location  => 'openio2',
}
openiosds::meta1 {'meta1-3':
  num       => '3',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6082',
  location  => 'openio3',
}
openiosds::meta2 {'meta2-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6003',
  location  => 'openio1',
}
openiosds::meta2 {'meta2-2':
  num       => '2',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6073',
  location  => 'openio2',
}
openiosds::meta2 {'meta2-3':
  num       => '3',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6083',
  location  => 'openio3',
}
openiosds::rawx {'rawx-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6004',
  location  => 'openio1',
}
openiosds::rawx {'rawx-2':
  num       => '2',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6074',
  location  => 'openio2',
}
openiosds::rawx {'rawx-3':
  num       => '3',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6084',
  location  => 'openio3',
}
openiosds::oioblobindexer {'oio-blob-indexer-rawx-1':
  num => '1',
  ns  => 'OPENIO',
}
openiosds::oioblobindexer {'oio-blob-indexer-rawx-2':
  num => '2',
  ns  => 'OPENIO',
}
openiosds::oioblobindexer {'oio-blob-indexer-rawx-3':
  num => '3',
  ns  => 'OPENIO',
}
openiosds::rdir {'rdir-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6010',
  location  => 'openio1',
}
openiosds::rdir {'rdir-2':
  num       => '2',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6070',
  location  => 'openio2',
}
openiosds::rdir {'rdir-3':
  num       => '3',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6080',
  location  => 'openio3',
}
openiosds::oioeventagent {'oio-event-agent-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6008',
}
openiosds::oioproxy {'oioproxy-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => '0.0.0.0',
  port      => '6006',
}
openiosds::redis {'redis-0':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6011',
}
openiosds::conscienceagent {'conscienceagent-1':
  num => '1',
  ns  => 'OPENIO',
}
openiosds::beanstalkd {'beanstalkd-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6014',
}
openiosds::ecd {'ecd-1':
  num       => '1',
  ns        => 'OPENIO',
  ipaddress => $ipaddr,
  port      => '6017',
}
