require 'spec_helper'

describe 'mozilla_ssh_hardening::server' do
  context 'with version 7.2p2' do

    let(:facts) do
      {
        :osfamily            => 'RedHat',
        :sshd_server_version => '7.2p2',
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

    [
      'HostKey /etc/ssh/ssh_host_ed25519_key\nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_ecdsa_key',
      'KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256',
      'Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr',
      'MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com',
      'AuthenticationMethods publickey',
      'LogLevel VERBOSE',
      'Subsystem sftp /usr/lib/ssh/sftp-server -f AUTHPRIV -l INFO',
      'PermitRootLogin no',
      'UsePrivilegeSeparation sandbox',
      'AuthorizedKeysFile %h/.ssh/authorized_keys /etc/ssh/%u/authorized_key',
    ].each do | mozzila_ssh_chunk |
      it { should contain_concat__fragment('global config').with_content(Regexp.new(mozzila_ssh_chunk))}
    end

  end

end
