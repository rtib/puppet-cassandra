# frozen_string_literal: true

require 'spec_helper'

describe 'cassandra::jvm_option_set' do
  let(:pre_condition) { 'include cassandra' }

  on_supported_os.each do |os, os_facts|
    let(:facts) { os_facts }

    context 'add/remove options' do
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
    context 'add/remove properties' do
      let(:title) { 'a/r props' }
      let(:params) do
        {
          'properties' => {
            'test1' => :undef,
            'test2' => 'bla',
          },
        }
      end

      it { is_expected.to compile.with_all_deps }
      it do
        is_expected.to contain_file_line('a/r props remove property test1')
          .with_ensure('absent')
          .with_match("^-Dtest1")
          .with_match_for_absence(true)
      end
      it do
        is_expected.to contain_file_line('a/r props set property test2')
          .with_ensure('present')
          .with_line('-Dtest2=bla')
          .with_match('^-Dtest2')
      end
    end
  end
end
