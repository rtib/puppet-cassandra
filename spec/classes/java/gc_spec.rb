require 'spec_helper'

describe 'cassandra::java::gc' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) { 'include cassandra' }
      let(:facts) { os_facts }
      let(:params) do 
        {
          'collector' => 'g1',
        }
      end

      it { is_expected.to compile }
    end
  end
end
