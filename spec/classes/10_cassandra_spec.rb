require 'spec_helper'

describe 'cassandra' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('cassandra') }
      it do
        is_expected.to contain_class('cassandra::install')
          .that_comes_before('Class[cassandra::config]')
          .that_comes_before('Class[cassandra::config::topology]')
      end
      it { is_expected.to contain_class('cassandra::config') }
      it { is_expected.to contain_class('cassandra::config::topology') }
      it { is_expected.to contain_class('cassandra::service').that_subscribes_to('Class[cassandra::config]') }
    end
  end
end
