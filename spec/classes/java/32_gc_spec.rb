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
        it { is_expected.to contain_notify('The class cassandra::java::gc is deprecated now, consider using cassandra::jvm_option_sets instead!') }
        it do
          is_expected.to contain_file('/etc/cassandra/jvm.options')
            .with_ensure('file')
            .with_content(%r{^\-XX:\+UseG1GC$})
        end
      end

      context 'g1 /w params' do
        let(:params) do
          {
            'collector' => 'g1',
            'params'    => {
              'maxGCPauseMillis' => 300,
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_notify('The class cassandra::java::gc is deprecated now, consider using cassandra::jvm_option_sets instead!') }
        it do
          is_expected.to contain_file('/etc/cassandra/jvm.options')
            .with_ensure('file')
            .with_content(%r{^\-XX:\+UseG1GC$})
            .with_content(%r{^\-XX:MaxGCPauseMillis=300$})
        end
      end

      context 'cms default setup' do
        let(:params) do
          {
            'collector' => 'cms',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_notify('The class cassandra::java::gc is deprecated now, consider using cassandra::jvm_option_sets instead!') }
        it do
          is_expected.to contain_file('/etc/cassandra/jvm.options')
            .with_ensure('file')
            .with_content(%r{^\-XX:\+UseParNewGC$})
            .with_content(%r{^\-XX:\+UseConcMarkSweepGC$})
            .with_content(%r{^\-XX:\+CMSParallelRemarkEnabled$})
            .with_content(%r{^\-XX:\+CMSClassUnloadingEnabled$})
        end
      end

      context 'cms /w params' do
        let(:params) do
          {
            'collector' => 'cms',
            'params'    => {
              'gCLogFileSize' => '5M',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_notify('The class cassandra::java::gc is deprecated now, consider using cassandra::jvm_option_sets instead!') }
        it do
          is_expected.to contain_file('/etc/cassandra/jvm.options')
            .with_ensure('file')
            .with_content(%r{^\-XX:\+UseParNewGC$})
            .with_content(%r{^\-XX:\+UseConcMarkSweepGC$})
            .with_content(%r{^\-XX:\+CMSParallelRemarkEnabled$})
            .with_content(%r{^\-XX:\+CMSClassUnloadingEnabled$})
            .with_content(%r{^\-XX:GCLogFileSize=5M$})
        end
      end
    end
  end
end
