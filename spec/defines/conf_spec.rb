require 'spec_helper'

describe 'sudo::conf' do

  on_supported_os.each do |os,facts|
    context "on #{os}" do
      let(:title) {'admin_users'}
      let(:facts) do
        facts.merge({path: '/usr/bin:/usr/sbin'})
      end
      let(:params) do
        {
          ensure:  'present',
          content: 'foobar'
        }
      end
      it { is_expected.to contain_file('/etc/sudoers.d/10_admin_users') }
      it { is_expected.to contain_file('/etc/sudoers.d/10_admin_users').with_content('foobar') }
      context 'with selective_purge true on main class' do
        let(:pre_condition) do
          'class{"sudo": selective_purge => true,}'
        end
        it { is_expected.to contain_file('/etc/sudoers.d/10_admin_users_puppet') }
        it { is_expected.to contain_file('/etc/sudoers.d/10_admin_users_puppet').with_content('foobar') }
      end
    end
  end
end
