require 'spec_helper'

describe 'cassandra::java::property' do
  let(:pre_condition) { 'include cassandra' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'string property' do
        let(:title) { 'strproperty' }
        let(:params) do
          {
            'value' => 'testvalue',
          }
        end

        it { is_expected.to compile }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('Dstrproperty=testvalue')
        end
      end
      describe 'integer property' do
        let(:title) { 'intproperty' }
        let(:params) do
          {
            'value' => 1234,
          }
        end

        it { is_expected.to compile }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('Dintproperty=1234')
        end
      end
      describe 'boolean property true' do
        let(:title) { 'boolproperty1' }
        let(:params) do
          {
            'value' => true,
          }
        end

        it { is_expected.to compile }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('Dboolproperty1=true')
        end
      end
      describe 'boolean property false' do
        let(:title) { 'boolproperty0' }
        let(:params) do
          {
            'value' => false,
          }
        end

        it { is_expected.to compile }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('Dboolproperty0=false')
        end
      end
    end
  end
end
