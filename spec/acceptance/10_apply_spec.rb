require 'spec_helper_acceptance'

describe 'apply module' do
  pp = <<-PUPPETCODE
  class { 'cassandra':
    manage_service    => true,
    service_enable    => true,
    service_ensure    => 'running',
    config            => {
      'cluster_name' => 'Test cluster',
      'num_tokens'   => 64,
      'seed_provider' => [
        {
          'class_name' => 'org.apache.cassandra.locator.SimpleSeedProvider',
          'parameters' => [ { 'seeds' => 'localhost'} ],
        },
      ],
    },
  }
PUPPETCODE

  it 'applies idempotently' do
    idempotent_apply(pp)
  end
end
