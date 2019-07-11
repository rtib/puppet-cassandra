require 'spec_helper_acceptance'
require 'rspec/retry'

context 'service tests' do
  describe port(9042) do
    it 'port 9042 is eventually listening', retry: 15, retry_wait: 10 do
      is_expected.to be_listening
    end
  end

  describe 'nodetool info', retry: 15, retry_wait: 10 do
    subject(:nodetool_info) { run_shell('nodetool info') }

    its(:exit_code) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{Gossip active *: true} }
    its(:stdout) { is_expected.to match %r{Native Transport active *: true} }
  end

  describe 'nodetool describecluster', retry: 15, retry_wait: 10 do
    subject(:nodetool_describecluster) { run_shell('nodetool describecluster') }

    its(:exit_code) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{Name: Test cluster} }
  end
end
