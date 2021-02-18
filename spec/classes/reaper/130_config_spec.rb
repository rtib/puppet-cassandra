# frozen_string_literal: true

require 'spec_helper'

describe 'cassandra::reaper' do
  describe 'cassandra::reaper::config' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        context 'all default' do
          let(:facts) { os_facts }

          it { is_expected.to compile }
          it do
            is_expected.to contain_yaml_settings('cassandra::reaper::config')
              .with_source(nil)
              .with_target('/etc/cassandra-reaper/cassandra-reaper.yaml')
          end
        end
        context 'using template /wo settings' do
          let(:facts) { os_facts }
          let(:params) do
            {
              'template' => 'cassandra-reaper-cassandra-sidecar',
            }
          end

          it { is_expected.to compile }
          it do
            is_expected.to contain_yaml_settings('cassandra::reaper::config')
              .with_source('/etc/cassandra-reaper/configs/cassandra-reaper-cassandra-sidecar.yaml')
              .with_target('/etc/cassandra-reaper/cassandra-reaper.yaml')
          end
        end
        context 'using template /w settings' do
          let(:facts) { os_facts }
          let(:params) do
            {
              'template' => 'cassandra-reaper-cassandra-sidecar',
              'settings' => {'purgeRecordsAfterInDays' => 30 }
            }
          end

          it { is_expected.to compile }
          it do
            is_expected.to contain_yaml_settings('cassandra::reaper::config')
              .with_source('/etc/cassandra-reaper/configs/cassandra-reaper-cassandra-sidecar.yaml')
              .with_target('/etc/cassandra-reaper/cassandra-reaper.yaml')
              .with_values('purgeRecordsAfterInDays' => 30)
          end
        end
      end
    end
  end
end
