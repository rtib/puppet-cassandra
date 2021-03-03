# frozen_string_literal: true

require 'spec_helper'

describe 'cassandra::reaper' do
  describe 'cassandra::reaper::service' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        it { is_expected.to compile }
        it do
          is_expected.to contain_service('cassandra-reaper')
            .with_ensure('running')
            .with_enable(true)
        end
      end
    end
  end
end
