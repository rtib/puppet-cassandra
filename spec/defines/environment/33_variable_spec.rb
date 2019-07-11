require 'spec_helper'

describe 'cassandra::environment::variable' do
  let(:pre_condition) { 'include cassandra' }
  let(:title) { 'testvariable' }
  let(:params) do
    {
      'value' => 'testvalue',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it do
        is_expected.to contain_concat__fragment('cassandra::environment::variable[testvariable]=testvalue')
          .with_target('/var/lib/cassandra/.cassandra.in.sh')
          .with_order('10')
          .with_content(%r{^testvariable=\"testvalue\"$})
      end
    end
  end
end
