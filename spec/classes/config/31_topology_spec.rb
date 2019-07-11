require 'spec_helper'

describe 'cassandra' do
  describe 'cassandra::config::topology' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'default setup' do
          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file('/etc/cassandra/cassandra-topology.properties')
              .with_ensure('absent')
          end
        end

        context 'topology setup' do
          let(:params) do
            {
              'topology' => {
                'dc1' => {
                  'A' => ['10.0.0.1', '10.0.0.2'],
                  'B' => ['10.0.0.3', '10.0.0.4'],
                },
                'dc2' => {
                  'A' => ['10.0.1.1', '10.0.1.2'],
                  'B' => ['10.0.1.3', '10.0.1.4'],
                },
              },
            }
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file('/etc/cassandra/cassandra-topology.properties')
              .with_ensure('file')
              .with_content(%r{^10.0.0.1=dc1:A$})
              .with_content(%r{^10.0.0.2=dc1:A$})
              .with_content(%r{^10.0.0.3=dc1:B$})
              .with_content(%r{^10.0.0.4=dc1:B$})
              .with_content(%r{^10.0.1.1=dc2:A$})
              .with_content(%r{^10.0.1.2=dc2:A$})
              .with_content(%r{^10.0.1.3=dc2:B$})
              .with_content(%r{^10.0.1.4=dc2:B$})
          end
        end

        context 'topology /w default setup' do
          let(:params) do
            {
              'topology_default' => 'dc1:rackX',
              'topology'         => {
                'dc1' => {
                  'A' => ['10.0.0.1', '10.0.0.2'],
                  'B' => ['10.0.0.3', '10.0.0.4'],
                },
                'dc2' => {
                  'A' => ['10.0.1.1', '10.0.1.2'],
                  'B' => ['10.0.1.3', '10.0.1.4'],
                },
              },
            }
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file('/etc/cassandra/cassandra-topology.properties')
              .with_ensure('file')
              .with_content(%r{^10.0.0.1=dc1:A$})
              .with_content(%r{^10.0.0.2=dc1:A$})
              .with_content(%r{^10.0.0.3=dc1:B$})
              .with_content(%r{^10.0.0.4=dc1:B$})
              .with_content(%r{^10.0.1.1=dc2:A$})
              .with_content(%r{^10.0.1.2=dc2:A$})
              .with_content(%r{^10.0.1.3=dc2:B$})
              .with_content(%r{^10.0.1.4=dc2:B$})
              .with_content(%r{^default=dc1:rackX$})
          end
        end

        context 'broken topology setup' do
          let(:params) do
            {
              'topology' => {
                'dc1' => {
                  'A' => ['10.0.0.1', '10.0.0.2'],
                  'B' => '10.0.0.3',
                },
                'dc2' => {
                  'A' => ['10.0.1.1', '10.0.1.2'],
                  'B' => ['10.0.1.3', '10.0.1.4'],
                },
              },
            }
          end

          it do
            expect {
              is_expected.to contain_file('/etc/cassandra/cassandra-topology.properties')
                .with_ensure('file')
            }.to raise_error(Puppet::Error)
          end
        end
      end
    end
  end
end
