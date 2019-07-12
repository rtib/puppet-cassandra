require 'spec_helper'

describe 'cassandra::java::runtimeoption' do
  let(:pre_condition) { 'include cassandra' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'simple option' do
        let(:title) { 'testoption' }

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('Xtestoption')
        end
      end

      context 'option /w parameter' do
        let(:title) { 'testoption2' }
        let(:params) do
          {
            'value' => 'testvalue',
          }
        end

        it { is_expected.to compile }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('Xtestoption2=testvalue')
        end
      end
    end
  end
end
