# frozen_string_literal: true

require 'spec_helper'

describe 'cassandra::jvm_option_set' do
  let(:pre_condition) { 'include cassandra' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'Cassandra 4 Java-8 server options' do
        let(:title) { 'C*4 Java-8 server options' }
        let(:params) do
          {
            'optsfile'   => 'jvm8',
            'variant'    => 'server',
            'advancedoptions' => {
              'ThreadPriorityPolicy' => 42,
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file_line('C*4 Java-8 server options set advanced runtime option ThreadPriorityPolicy')
            .with_ensure('present')
            .with_path('/etc/cassandra/jvm8-server.options')
            .with_match('^-XX:ThreadPriorityPolicy')
            .with_line('-XX:ThreadPriorityPolicy=42')
        end
      end
      context 'Cassandra 4 Java-11 server options' do
        let(:title) { 'C*4 Java-11 server options' }
        let(:params) do
          {
            'optsfile'   => 'jvm11',
            'variant'    => 'server',
            'advancedoptions' => {
              'ThreadPriorityPolicy' => 42,
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file_line('C*4 Java-11 server options set advanced runtime option ThreadPriorityPolicy')
            .with_ensure('present')
            .with_path('/etc/cassandra/jvm11-server.options')
            .with_match('^-XX:ThreadPriorityPolicy')
            .with_line('-XX:ThreadPriorityPolicy=42')
        end
      end
      context 'Cassandra 4 indep server options' do
        let(:title) { 'C*4 indep server options' }
        let(:params) do
          {
            'variant'    => 'server',
            'properties' => {
              'cassandra.available_processors' => 4,
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file_line('C*4 indep server options set property cassandra.available_processors')
            .with_ensure('present')
            .with_path('/etc/cassandra/jvm-server.options')
            .with_match('^-Dcassandra.available_processors')
            .with_line('-Dcassandra.available_processors=4')
        end
      end
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
            .with_line('-ea')
        end
        it do
          is_expected.to contain_file_line('a/r opts set option server')
            .with_ensure('present')
            .with_line('-server')
        end
      end
      context 'add/remove size options' do
        let(:title) { 'a/r size options' }
        let(:params) do
          {
            'sizeoptions' => {
              'Xmn' => :undef,
              'Xmx' => '8G',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file_line('a/r size options remove size option Xmn')
            .with_ensure('absent')
            .with_match('^-Xmn')
            .with_match_for_absence(true)
        end
        it do
          is_expected.to contain_file_line('a/r size options set size option Xmx')
            .with_ensure('present')
            .with_line('-Xmx8G')
            .with_match('^-Xmx')
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
            .with_match('^-Dtest1')
            .with_match_for_absence(true)
        end
        it do
          is_expected.to contain_file_line('a/r props set property test2')
            .with_ensure('present')
            .with_line('-Dtest2=bla')
            .with_match('^-Dtest2')
        end
      end
      context 'add/remove advanced options' do
        let(:title) { 'a/r adv opts' }
        let(:params) do
          {
            'advancedoptions' => {
              'test1' => :undef,
              'test2' => true,
              'test3' => false,
              'test4' => 'bla',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file_line('a/r adv opts remove advanced runtime option test1')
            .with_ensure('absent')
            .with_match('^-XX:[+-]?test1')
            .with_match_for_absence(true)
        end
        it do
          is_expected.to contain_file_line('a/r adv opts set boolean advanced runtime option test2')
            .with_ensure('present')
            .with_line('-XX:+test2')
            .with_match('^-XX:[+-]test2')
        end
        it do
          is_expected.to contain_file_line('a/r adv opts set boolean advanced runtime option test3')
            .with_ensure('present')
            .with_line('-XX:-test3')
            .with_match('^-XX:[+-]test3')
        end
        it do
          is_expected.to contain_file_line('a/r adv opts set advanced runtime option test4')
            .with_ensure('present')
            .with_line('-XX:test4=bla')
            .with_match('^-XX:test4')
        end
      end
    end
  end
end
