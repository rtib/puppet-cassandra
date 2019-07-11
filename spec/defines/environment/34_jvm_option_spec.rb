require 'spec_helper'

describe 'cassandra::environment::jvm_option' do
  let(:pre_condition) { 'include cassandra' }
  let(:title) { 'verbose:gc' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it do
        is_expected.to contain_cassandra__environment__variable('cassandra::environment::jvm_option[verbose:gc]')
          .with_value('$JVM_EXTRA_OPTS -verbose:gc')
      end
    end
  end
end
