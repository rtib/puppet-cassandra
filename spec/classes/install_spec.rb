require 'spec_helper'

describe 'cassandra' do
  describe 'cassandra::install' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:pre_condition) { 'include cassandra' }

        it { is_expected.to compile }
        it do
          is_expected.to contain_package('cassandra')
          is_expected.to contain_package('cassandra-tools')
        end
      end
    end
  end
end
