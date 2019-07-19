# Service enable can be `manual` or `mask` besides the Boolean.
type Cassandra::Service::Enable = Variant[Boolean, Enum['manual','mask']]
