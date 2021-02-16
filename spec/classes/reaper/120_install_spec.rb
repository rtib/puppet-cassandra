# frozen_string_literal: true

require 'spec_helper'

describe 'cassandra::reaper' do
  describe 'cassandra::reaper::install' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        context 'install default' do
          let(:facts) { os_facts }

          it { is_expected.to compile }
          it do
            is_expected.to contain_package('reaper')
              .with_ensure('latest')
          end
        end
        context 'install specific version' do
          let(:facts) { os_facts }
          let(:params) do
            {
              'ensure_package' => '1.2.3',
            }
          end

          it { is_expected.to compile }
          it do
            is_expected.to contain_package('reaper')
              .with_ensure('1.2.3')
          end
        end
      end
    end
  end
end
