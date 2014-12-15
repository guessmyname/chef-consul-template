require 'spec_helper'

describe 'consul-template::service' do
  let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  it 'should create the consul-template config directory' do
    expect(chef_run).to create_directory('/etc/consul-template.d')
  end

  it 'should create the consul-template default config' do
    expect(chef_run).to create_template('/etc/consul-template.d/default.json')
  end

  it 'should create the consul-template init script' do
    expect(chef_run).to create_template('/etc/init.d/consul-template')
  end

  it 'should enable the consul-template service' do
    expect(chef_run).to enable_service('consul-template')
  end

  it 'should start the consul-template service' do
    expect(chef_run).to start_service('consul-template')
  end

  context 'when using init' do
    it 'should not create the consul-template service user (using root)' do
      expect(chef_run).to_not create_user('root')
    end

    it 'should not create the consul-template service group (using root)' do
      expect(chef_run).to_not create_group('root')
    end
  end

  context 'when using runit' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['consul_template']['init_style'] = 'runit'
      end.converge(described_recipe)
    end

    it 'should create the consul-template service user' do
      expect(chef_run).to create_user('consul-template')
    end

    it 'should create the consul-template service group' do
      expect(chef_run).to create_group('consul-template')
    end

    it 'should create the consul-template log directory' do
      expect(chef_run).to create_directory('/var/log/consul-template')
    end

    it 'should enable the consul-template service' do
      expect(chef_run).to enable_runit_service('consul-template')
    end

    it 'should start the consul-template service' do
      expect(chef_run).to start_runit_service('consul-template')
    end
  end
end