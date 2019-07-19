# Hash allowing to setup the content of `cassandra-rackdc.properties`. 
# Note, that the fields `dc` and `rack` mandatory to setup rackdc, while
# `dc_suffix` and `prefer_local` can be set optionally.
type Cassandra::Rackdc = Struct[{
  dc           => String,
  rack         => String,
  dc_suffix    => Optional[String],
  prefer_local => Optional[Boolean],
}]
