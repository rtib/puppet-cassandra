require 'spec_helper'

describe 'cassandra' do
  describe 'cassandra::install' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'default install' do
          let(:pre_condition) { 'include cassandra' }

          it { is_expected.to compile }
          it do
            is_expected.to contain_package('cassandra')
              .with_ensure('installed')
          end
          it do
            is_expected.to contain_package('cassandra-tools')
              .with_ensure('installed')
          end
        end
        context 'specific version install' do
          let(:params) do
            {
              'cassandra_ensure' => '3.0.18',
            }
          end

          it do
            is_expected.to contain_package('cassandra')
              .with_ensure('3.0.18')
          end
          it do
            is_expected.to contain_package('cassandra-tools')
              .with_ensure('3.0.18')
          end
        end
        context 'different tools and cassandra version install' do
          let(:params) do
            {
              'tools_ensure' => '3.0.18',
            }
          end

          it do
            is_expected.to contain_package('cassandra')
              .with_ensure('installed')
          end
          it do
                is_expected.to contain_package('cassandra-tools')
              .with_ensure('3.0.18')
          end
        end
      end
    end
  end
end
