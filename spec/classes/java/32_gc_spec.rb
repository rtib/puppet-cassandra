require 'spec_helper'

describe 'cassandra::java::gc' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) { 'include cassandra' }
      let(:facts) { os_facts }

      context 'g1 default setup' do
        let(:params) do
          {
            'collector' => 'g1',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('/etc/cassandra/jvm.options')
            .with_ensure('file')
            .with_content(%r{^\-XX:\+UseG1GC$})
        end
      end

      context 'cms default setup' do
        let(:params) do
          {
            'collector' => 'cms',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('/etc/cassandra/jvm.options')
            .with_ensure('file')
            .with_content(%r{^\-XX:\+UseParNewGC$})
            .with_content(%r{^\-XX:\+UseConcMarkSweepGC$})
            .with_content(%r{^\-XX:\+CMSParallelRemarkEnabled$})
            .with_content(%r{^\-XX:\+CMSClassUnloadingEnabled$})
        end
      end
    end
  end
end