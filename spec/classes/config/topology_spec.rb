require 'spec_helper'

describe 'cassandra::config::topology' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) { 'include cassandra' }
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end