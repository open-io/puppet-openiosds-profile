openiosds::sdsagent {'sds-agent-0':
}
openiosds::namespace {'OPENIO':
  ns => 'OPENIO',
  conscience_url => "${ipaddress}:6000",
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
