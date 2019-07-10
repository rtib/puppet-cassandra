require 'spec_helper_acceptance'

context 'configuration checks' do
  describe file('/etc/cassandra/cassandra.yaml') do
    it { is_expected.to be_file }
    its(:content_as_yaml) { is_expected.to include('cluster_name' => 'Test cluster') }
    its(:content_as_yaml) { is_expected.to include('num_tokens'   => 64) }
    its(:content_as_yaml) { is_expected.to include('seed_provider' => [include('parameters' => [include('seeds' => 'localhost')])]) }
  end

  describe service('cassandra') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
