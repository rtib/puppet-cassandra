require 'spec_helper'

describe 'cassandra::java::agent' do
  let(:pre_condition) { 'include cassandra' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'simple agent' do
        let(:title) { 'testAgent1' }

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('javaagent:testAgent1')
        end
      end

      context 'agent /w param' do
        let(:title) { 'testAgent2' }
        let(:params) do
          {
            'value' => 'param'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('javaagent:testAgent2=param')
        end
      end
    end
  end
end
