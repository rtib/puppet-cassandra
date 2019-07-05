require 'spec_helper_acceptance'

describe 'apply module' do
  pp = <<-PUPPETCODE
    include cassandra
  PUPPETCODE

  it 'applies idempotently' do
    idempotent_apply(pp)
  end
end
