# frozen_string_literal: true

require 'spec_helper'

describe 'patroni::instance' do
  on_supported_os.each do |os, os_facts|
    let(:title) { 'cluster1' }
    let :pre_condition do
      <<-PUPPET
      class { 'patroni':
        scope => 'internal',
      }
      PUPPET
    end
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'with defaults' do
        it { is_expected.not_to compile }
      end
      context 'with minimal params' do
        let :params do
          {
            config: { foo: 'value' }
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
