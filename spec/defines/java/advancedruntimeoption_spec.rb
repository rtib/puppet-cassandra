require 'spec_helper'

describe 'cassandra::java::advancedruntimeoption' do
  let(:pre_condition) { 'include cassandra' }
  let(:title) { 'testtitle' }
  let(:params) do
    {
      'value' => 'testvalue',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end