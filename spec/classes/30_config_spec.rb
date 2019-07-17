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

        context 'environment variables' do
          let(:params) do
            {
              'environment' => {
                'MAX_HEAP_SIZE' => '8G',
                'HEAP_NEWSIZE'  => '2G',
              },
            }
          end

          it do
            is_expected.to contain_cassandra__environment__variable('MAX_HEAP_SIZE')
              .with_value('8G')
            is_expected.to contain_cassandra__environment__variable('HEAP_NEWSIZE')
              .with_value('2G')
          end
        end

        context 'environment jvm_options' do
          let(:params) do
            {
              'jvm_options' => [
                'verbose:gc',
                'server'
              ],
            }
          end

          it do
            is_expected.to contain_cassandra__environment__jvm_option('verbose:gc')
            is_expected.to contain_cassandra__environment__jvm_option('server')
          end
        end

        context 'java settings' do
          let(:params) do
            {
              'java' => {
                'properties' => {
                  'cassandra.consistent.rangemovement' => 'false',
                  'cassandra.replace_address' => '10.0.0.2',
                },
                'agents' => {
                  'jmx_prometheus_javaagent-0.12.0.jar' => '8080:config.yaml',
                },
                'runtime_options' => {
                  # 'diag' => undef,
                  'check' => 'jni',
                },
                'adv_runtime_options' => {
                  'LargePageSizeInBytes' => '2m',
                  'UseLargePages' => true,
                  'AlwaysPreTouch' => true,
                }
              },
            }
          end

          it do
            is_expected.to contain_cassandra__java__property('cassandra.consistent.rangemovement')
              .with_value('false')
              is_expected.to contain_cassandra__java__property('cassandra.replace_address')
              .with_value('10.0.0.2')
          end
          it do
            is_expected.to contain_cassandra__java__agent('jmx_prometheus_javaagent-0.12.0.jar')
              .with_value('8080:config.yaml')
          end
          it do
            # is_expected.to contain_cassandra__java__runtimeoption('diag')
            #   .without_value
            is_expected.to contain_cassandra__java__runtimeoption('check')
              .with_value('jni')
          end
          it do
            is_expected.to contain_cassandra__java__advancedruntimeoption('LargePageSizeInBytes')
              .with_value('2m')
            is_expected.to contain_cassandra__java__advancedruntimeoption('UseLargePages')
              .with_value(true)
            is_expected.to contain_cassandra__java__advancedruntimeoption('AlwaysPreTouch')
              .with_value(true)
          end
        end
      end
    end
  end
end
