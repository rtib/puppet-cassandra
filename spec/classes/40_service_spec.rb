require 'spec_helper'

describe 'cassandra' do
  describe 'cassandra::service' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'default setup' do
          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_service('cassandra')
              .without_ensure
              .with_enable(false)
          end
        end
        context 'service enabled and running setup' do
          let(:params) do
            {
              'service_ensure' => 'running',
              'service_enable' => true,
            }
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_service('cassandra')
              .with_ensure('running')
              .with_enable(true)
          end
        end
      end
    end
  end
end
