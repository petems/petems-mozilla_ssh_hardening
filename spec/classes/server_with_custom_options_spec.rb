require 'spec_helper'

describe 'mozilla_ssh_hardening::server' do
  context 'with custom options' do

    let(:facts) do
      {
        :osfamily            => 'RedHat',
        :ssh_server_version_full => '7.2p2',
      }
    end

    let(:params) do
      {
        :extra_config => {
          'AllowUsers' => ['bob alice']
        }
      }
    end

    it do
      should contain_file('/etc/ssh').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      )
    end

    it { should contain_class('mozilla_ssh_hardening::server')}

    it { should contain_class('ssh::server').with_storeconfigs_enabled(false) }

    it { should contain_concat__fragment('global config').with_content(/AllowUsers bob alice/)}

  end

  context 'with custom options that overwrite defaults' do

    let(:facts) do
      {
        :osfamily            => 'RedHat',
        :ssh_server_version_full => '7.2p2',
      }
    end

    let(:params) do
      {
        :extra_config => {
          'AllowTCPForwarding' => 'yes'
        }
      }
    end

    it do
      should contain_file('/etc/ssh').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      )
    end

    it { should contain_class('mozilla_ssh_hardening::server')}

    it { should contain_class('ssh::server').with_storeconfigs_enabled(false) }

    it { should contain_concat__fragment('global config').with_content(/AllowTCPForwarding yes/)}

  end

end
