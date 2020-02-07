require 'spec_helper'
describe 'sudo' do
  let (:facts) { {
    :sudoversion => '1.2.3',
  } }

  it { should compile.with_all_deps }
  it { should contain_file('/etc/sudoers.d').with_ensure('directory') }
  it { should contain_file('/etc/sudoers.d').without_ignore }
  context 'with booleans false' do
    let (:params) { {
      selective_purge: false
    } }
   it { should contain_file('/etc/sudoers.d').without_ignore }
  end
  context 'with booleans true' do
    let (:params) { {
      selective_purge: true
    } }
   it { should contain_file('/etc/sudoers.d').with_ignore('*[!_puppet]') }
  end
end
