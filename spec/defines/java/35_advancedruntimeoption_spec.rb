require 'spec_helper'

describe 'cassandra::java::advancedruntimeoption' do
  let(:pre_condition) { 'include cassandra' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'option switch on' do
        let(:title) { 'OptiOn' }
        let(:params) do
          {
            'value' => true,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('XX:+OptiOn')
        end
      end

      context 'option switch off' do
        let(:title) { 'OptiOff' }
        let(:params) do
          {
            'value' => false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('XX:-OptiOff')
        end
      end

      context 'option parameter' do
        let(:title) { 'Option' }
        let(:params) do
          {
            'value' => 'Parameter',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_cassandra__environment__jvm_option('XX:Option=Parameter')
        end
      end
    end
  end
end
