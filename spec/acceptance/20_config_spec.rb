require 'spec_helper_acceptance'

CONFIG_DIR = {
  'debian' => '/etc/cassandra',
  'ubuntu' => '/etc/cassandra',
  'redhat' => '/etc/cassandra/conf',
}.freeze

describe file(File.join(CONFIG_DIR[os[:family]], 'cassandra.yaml')) do
  it { is_expected.to be_file }
  its(:content_as_yaml) { is_expected.to include('cluster_name' => 'Test cluster') }
  its(:content_as_yaml) { is_expected.to include('num_tokens'   => 64) }
  its(:content_as_yaml) { is_expected.to include('seed_provider' => [include('parameters' => [include('seeds' => 'localhost')])]) }
end

describe service('cassandra') do
  it { is_expected.to be_enabled }
  it { is_expected.to be_running }
end
