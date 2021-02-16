# frozen_string_literal: true

require 'spec_helper'

describe 'cassandra::reaper' do
  describe 'cassandra::reaper::config' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        context 'all default' do
          let(:facts) { os_facts }

          it { is_expected.to compile }
        end
      end
    end
  end
end
