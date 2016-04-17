class {'openiosds':}
openiosds::namespace {'OPENIO':
  ns             => 'OPENIO',
  conscience_url => "${ipaddress}:6000",
  oioproxy_url   => "${ipaddress}:6006",
  eventagent_url => "beanstalk://${ipaddress}:6014",
}
openiosds::account {'account-0':
  ns => 'OPENIO',
}
openiosds::conscience {'conscience-0':
  ns => 'OPENIO',
}
openiosds::meta0 {'meta0-0':
  ns => 'OPENIO',
}
openiosds::meta1 {'meta1-0':
  ns => 'OPENIO',
}
openiosds::meta2 {'meta2-0':
  ns => 'OPENIO',
}
openiosds::rawx {'rawx-0':
  ns => 'OPENIO',
}
openiosds::rdir {'rdir-0':
  ns => 'OPENIO',
}
openiosds::oioblobindexer {'oio-blob-indexer-rawx-0':
  ns => 'OPENIO',
}
openiosds::oioeventagent {'oio-event-agent-0':
  ns => 'OPENIO',
}
openiosds::oioproxy {'oioproxy-0':
  ns => 'OPENIO',
}
openiosds::redis {'redis-0':
  ns => 'OPENIO',
}
openiosds::conscienceagent {'conscienceagent-0':
  ns => 'OPENIO',
}
openiosds::beanstalkd {'beanstalkd-0':
  ns => 'OPENIO',
}
