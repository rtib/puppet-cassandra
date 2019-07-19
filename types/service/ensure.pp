# This type is simply missing from Stdlib.
type Cassandra::Service::Ensure = Optional[Variant[Boolean,Enum['stopped', 'running']]]
