# frozen_string_literal: true

require 'rspec/retry'
include PuppetLitmus

node_vars = vars_from_node(inventory_hash_from_inventory_file, ENV['TARGET_HOST']) || {}

if node_vars.key?('release')
  bolt_upload_file(File.join(File.dirname(__FILE__), 'fixtures', "cassandra_#{node_vars['release']}.sources.list"), '/etc/apt/sources.list.d/cassandra.sources.list')
  run_shell('apt-get update')
end
