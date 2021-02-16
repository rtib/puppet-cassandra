# frozen_string_literal: true

require 'spec_helper'

describe 'cassandra::reaper' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('cassandra::reaper') }
      it do
        is_expected.to contain_class('cassandra::reaper::install')
          .that_comes_before('Class[cassandra::reaper::config]')
      end
      it { is_expected.to contain_class('cassandra::reaper::config') }
      it do
        is_expected.to contain_class('cassandra::reaper::service')
          .that_subscribes_to('Class[cassandra::reaper::config]')
      end
    end
  end
end
