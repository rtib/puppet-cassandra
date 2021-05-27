require 'spec_helper_acceptance'

context 'configuration checks' do
  describe file('/etc/cassandra/cassandra.yaml') do
    it { is_expected.to be_file }
    its(:content_as_yaml) do
      is_expected.to include('cluster_name' => 'Test cluster')
      is_expected.to include('num_tokens'   => 64)
      is_expected.to include('seed_provider' => [include('parameters' => [include('seeds' => 'localhost')])])
    end
  end

  describe file('/etc/cassandra/cassandra-rackdc.properties') do
    it { is_expected.to be_file }
    its(:content) do
      is_expected.to match %r{^dc=test-dc1$}
      is_expected.to match %r{^rack=A01$}
    end
  end

  describe file('/etc/cassandra/cassandra-topology.properties') do
    it { is_expected.to be_file }
    its(:content) do
      is_expected.to match %r{^127.0.0.1=test-dc1:rackA01$}
      is_expected.to match %r{^127.0.0.2=test-dc1:rackA01$}
      is_expected.to match %r{^127.0.0.3=test-dc1:rackA02$}
      is_expected.to match %r{^127.0.0.4=test-dc1:rackA02$}
      is_expected.to match %r{^127.0.1.1=test-dc2:rackA01$}
      is_expected.to match %r{^127.0.1.2=test-dc2:rackA01$}
      is_expected.to match %r{^127.0.1.3=test-dc2:rackA02$}
      is_expected.to match %r{^127.0.1.4=test-dc2:rackA02$}
    end
  end

  describe service('cassandra') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
