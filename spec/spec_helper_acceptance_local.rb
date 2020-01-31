# frozen_string_literal: true

require 'rspec/retry'
include PuppetLitmus

bolt_upload_file(File.join(File.dirname(__FILE__), 'fixtures/cassandra_311x.sources.list'), '/etc/apt/sources.list.d/cassandra.sources.list')
run_shell('apt-get update')
