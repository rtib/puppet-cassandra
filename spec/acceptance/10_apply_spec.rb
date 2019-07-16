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
    rackdc => {
      'dc'   => 'test-dc1',
      'rack' => 'A01',
    },
    topology => {
      'test-dc1' => {
        'rackA01' => ['127.0.0.1', '127.0.0.2'],
        'rackA02' => ['127.0.0.3', '127.0.0.4'],
      },
      'test-dc2' => {
        'rackA01' => ['127.0.1.1', '127.0.1.2'],
        'rackA02' => ['127.0.1.3', '127.0.1.4'],
      },
    },
  }
PUPPETCODE

  it 'applies idempotently' do
    idempotent_apply(pp)
  end
end
