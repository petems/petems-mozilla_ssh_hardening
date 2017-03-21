require 'spec_helper'

describe 'mozilla_ssh_hardening::server' do
  context 'with version 5.3p1' do

    let(:facts) do
      {
        :osfamily            => 'RedHat',
        :sshd_server_version => '5.3p1'
      }
    end

    it do
      should contain_file('/etc/ssh').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755'
      )
    end

    it { should contain_class('ssh::server').with_storeconfigs_enabled(false) }

    [
      'HostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_ecdsa_key',
      'KexAlgorithms diffie-hellman-group-exchange-sha256',
      'MACs hmac-sha2-512,hmac-sha2-256',
      'Ciphers aes256-ctr,aes192-ctr,aes128-ctr',
      'RequiredAuthentications2 publickey',
      'LogLevel VERBOSE',
      'Subsystem sftp /usr/lib/ssh/sftp-server -f AUTHPRIV -l INFO',
      'PermitRootLogin no',
      'AuthorizedKeysFile %h/.ssh/authorized_keys',
      'AuthorizedKeysFile2 /etc/ssh/%u/authorized_keys',
    ].each do | mozzila_ssh_chunk |
      it { should contain_concat__fragment('global config').with_content(Regexp.new(mozzila_ssh_chunk))}
    end

  end

end
