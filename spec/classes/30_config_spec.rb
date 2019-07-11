require 'spec_helper'

describe 'cassandra' do
  describe 'cassandra::config' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'default setup' do
          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_concat('/var/lib/cassandra/.cassandra.in.sh')
              .with_ensure('present')
              .with_ensure_newline(true)
          end
          it do
            is_expected.to contain_concat__fragment('cassandra.in.sh header')
              .with_target('/var/lib/cassandra/.cassandra.in.sh')
              .with_order('01')
              .with_source('puppet:///modules/cassandra/cassandra.in.sh.header')
          end
          it { is_expected.to contain_class('cassandra::config::topology') }
          it { is_expected.to contain_class('cassandra::config::rackdc') }
          it do
            is_expected.to contain_yaml_settings('cassandra::config')
              .with_target('/etc/cassandra/cassandra.yaml')
          end
        end
        context 'alternate path setup' do
          let(:params) do
            {
              'cassandra_home' => '/opt/cassandra',
              'config_dir'     => '/etc/cassandra/conf-2',
            }
          end

          it do
            is_expected.to contain_concat('/opt/cassandra/.cassandra.in.sh')
              .with_ensure('present')
              .with_ensure_newline(true)
          end
          it do
            is_expected.to contain_concat__fragment('cassandra.in.sh header')
              .with_target('/opt/cassandra/.cassandra.in.sh')
              .with_order('01')
              .with_source('puppet:///modules/cassandra/cassandra.in.sh.header')
          end
          it { is_expected.to contain_class('cassandra::config::topology') }
          it { is_expected.to contain_class('cassandra::config::rackdc') }
          it do
            is_expected.to contain_yaml_settings('cassandra::config')
              .with_target('/etc/cassandra/conf-2/cassandra.yaml')
          end
        end
      end
    end
  end
end
