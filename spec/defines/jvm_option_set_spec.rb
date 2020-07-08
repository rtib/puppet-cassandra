# frozen_string_literal: true

require 'spec_helper'

describe 'cassandra::jvm_option_set' do
  let(:pre_condition) { 'include cassandra' }

  on_supported_os.each do |os, os_facts|
    let(:facts) { os_facts }

    context 'add/remove options'
    let(:title) { 'a/r opts' }
    let(:params) do
      {
        'options' => ['server', '~ea'],
      }
    end

    it { is_expected.to compile.with_all_deps }
    it do
      is_expected.to contain_file_line('a/r opts remove option ea')
        .with_ensure('absent')
        .with_line("-ea")
    end
    it do
      is_expected.to contain_file_line('a/r opts set option server')
        .with_ensure('present')
        .with_line("-server")
    end
  end
end
