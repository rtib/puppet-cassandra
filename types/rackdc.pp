type Cassandra::Rackdc = Struct[{
  dc           => String,
  rack         => String,
  dc_suffix    => Optional[String],
  prefer_local => Optional[Boolean],
}]
