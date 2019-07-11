require 'spec_helper'

describe 'cassandra::java::property' do
  let(:pre_condition) { 'include cassandra' }
  let(:title) { 'testproperty' }
  let(:params) do
    {
      'value' => 'testvalue',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it do
        is_expected.to contain_cassandra__environment__jvm_option('Dtestproperty=testvalue')
      end
    end
  end
end
