require 'spec_helper'

describe 'nodejs::definition' do
  let(:facts) { default_test_facts }
  let(:title) { '0.12.1' }

  let(:definition_path) do
    [
      '/test',
      'boxen',
      'node-build',
      'share',
      'node-build',
      title
    ].join('/')
  end

  context "with source" do
    let(:whatever_source) { 'puppet:///modules/nodejs/whatever_def' }
    let(:params) do
      {
        :source => whatever_source
      }
    end

    it do
      should contain_file(definition_path).with_source(whatever_source)
    end
  end

  it do
    should contain_class('nodejs')
    should contain_class('nodejs::build')

    should contain_file(definition_path).with({
      :source  => "puppet:///modules/nodejs/definitions/#{title}"
    })
  end
end
