openiosds::sdsagent {'sds-agent-0':
}
openiosds::namespace {'OPENIO':
  ns             => 'OPENIO',
  conscience_url => "${ipaddress}:6000",
  oioproxy_url   => "${ipaddress}:6006",
  eventagent_url => "tcp://${ipaddress}:6008",
}
openiosds::conscience {'conscience-1':
  num            => '1',
  ns             => 'OPENIO',
}
openiosds::meta0 {'meta0-1':
  num => '1',
  ns => 'OPENIO',
}
openiosds::meta1 {'meta1-1':
  num => '1',
  ns => 'OPENIO',
}
openiosds::meta2 {'meta2-1':
  num => '1',
  ns => 'OPENIO',
}
openiosds::rawx {'rawx-1':
  num => '1',
  ns => 'OPENIO',
}
openiosds::account {'account-1':
  num        => '1',
  ns         => 'OPENIO',
  redis_default_install => true,
  redis_host => '127.0.0.1',
  redis_port => '6379',
}
openiosds::oioeventagent {'oio-event-agent-1':
  num       => '1',
  ns        => 'OPENIO',
}
openiosds::oioproxy {'oioproxy-1':
  num       => '1',
  ns        => 'OPENIO',
}
