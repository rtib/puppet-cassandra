require 'spec_helper'

describe 'cassandra' do
  describe 'cassandra::config::rackdc' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'default setup' do
          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file('/etc/cassandra/cassandra-rackdc.properties')
              .with_ensure('absent')
          end
        end

        context 'dc/rack setup' do
          let(:params) do
            {
              'rackdc' => {
                'dc'   => 'test-dc1',
                'rack' => 'A01',
              },
            }
          end

          it do
            is_expected.to contain_file('/etc/cassandra/cassandra-rackdc.properties')
              .with_ensure('file')
              .with_content(%r{^dc=test-dc1$})
              .with_content(%r{^rack=A01$})
          end
        end

        context 'dc/rack /w suffix setup' do
          let(:params) do
            {
              'rackdc' => {
                'dc'        => 'test-dc1',
                'rack'      => 'A01',
                'dc_suffix' => '.example.com',
              },
            }
          end

          it do
            is_expected.to contain_file('/etc/cassandra/cassandra-rackdc.properties')
              .with_ensure('file')
              .with_content(%r{^dc=test-dc1$})
              .with_content(%r{^rack=A01$})
              .with_content(%r{^dc_suffix=.example.com$})
          end
        end

        context 'dc/rack /w prefer_local setup' do
          let(:params) do
            {
              'rackdc' => {
                'dc'           => 'test-dc1',
                'rack'         => 'A01',
                'prefer_local' => true,
              },
            }
          end

          it do
            is_expected.to contain_file('/etc/cassandra/cassandra-rackdc.properties')
              .with_ensure('file')
              .with_content(%r{^dc=test-dc1$})
              .with_content(%r{^rack=A01$})
              .with_content(%r{^prefer_local=true$})
          end
        end

        context 'incomplete dc/rack setup' do
          let(:params) do
            {
              'rackdc' => {
                'dc'           => 'test-dc1',
              },
            }
          end

          it do
            expect {
              is_expected.to contain_file('/etc/cassandra/cassandra-rackdc.properties')
                .with_ensure('file')
            }.to raise_error(Puppet::Error)
          end
        end
      end
    end
  end
end
