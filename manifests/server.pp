#
class mozilla_ssh_hardening::server (
  $use_pam                = false,
) {

  $ssh_66_onward = versioncmp($::sshd_server_version, '6.6') >= 0
  $ssh_59_onward = versioncmp($::sshd_server_version, '5.9') >= 0

  $older_ssh_options = {
    'RequiredAuthentications2' => 'publickey',
    'Ciphers'                  => 'aes256-ctr,aes192-ctr,aes128-ctr',
    'MACs'                     => 'hmac-sha2-512,hmac-sha2-256',
    'KexAlgorithms'            => 'diffie-hellman-group-exchange-sha256',
    'HostKey'                  =>[
      '/etc/ssh/ssh_host_rsa_key',
      '/etc/ssh/ssh_host_ecdsa_key',
    ],
    'AuthorizedKeysFile'       => '%h/.ssh/authorized_keys',
  }

  if $ssh_66_onward {
    $ssh_version_options = {
      'AuthenticationMethods'  => 'publickey',
      'Ciphers'                => 'chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr',
      'MACs'                   => 'hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com',
      'KexAlgorithms'          => 'curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256',
      'HostKey'                => [
        '/etc/ssh/ssh_host_ed25519_key',
        '/etc/ssh/ssh_host_rsa_key',
        '/etc/ssh/ssh_host_ecdsa_key',
      ],
      'UsePrivilegeSeparation' => 'sandbox',
      'AuthorizedKeysFile'     => '%h/.ssh/authorized_keys /etc/ssh/%u/authorized_keys',
    }
  } elsif $ssh_59_onward {
    $authorized_keys_options = {
      'AuthorizedKeysFile'       => '%h/.ssh/authorized_keys /etc/ssh/%u/authorized_keys',
    }
    $ssh_version_options = merge($older_ssh_options, $authorized_keys_options)
  } else {
    $authorized_keys_options = {
      'AuthorizedKeysFile'       => '%h/.ssh/authorized_keys',
      'AuthorizedKeysFile2'      => '/etc/ssh/%u/authorized_keys',
    }
    $ssh_version_options = merge($older_ssh_options, $authorized_keys_options)
  }

  $default_options = {
    'AddressFamily'                   => 'any',
    'AllowAgentForwarding'            => 'no',
    'AllowTcpForwarding'              => 'no',
    'ChallengeResponseAuthentication' => 'no',
    'ClientAliveCountMax'             => '3',
    'ClientAliveInterval'             => '600',
    'GatewayPorts'                    => 'no',
    'GSSAPIAuthentication'            => 'no',
    'GSSAPICleanupCredentials'        => 'yes',
    'HostbasedAuthentication'         => 'no',
    'IgnoreRhosts'                    => 'yes',
    'IgnoreUserKnownHosts'            => 'yes',
    'KerberosAuthentication'          => 'no',
    'KerberosOrLocalPasswd'           => 'no',
    'KerberosTicketCleanup'           => 'yes',
    'LoginGraceTime'                  => '30s',
    'LogLevel'                        => 'VERBOSE',
    'MaxAuthTries'                    => '2',
    'MaxSessions'                     => '10',
    'MaxStartups'                     => '10:30:100',
    'PasswordAuthentication'          => 'no',
    'PermitEmptyPasswords'            => 'no',
    'PermitRootLogin'                 => 'no',
    'PermitTunnel'                    => 'no',
    'PermitUserEnvironment'           => 'no',
    'Port'                            => '22',
    'PrintLastLog'                    => 'no',
    'PrintMotd'                       => 'no',
    'Protocol'                        => '2',
    'PubkeyAuthentication'            => 'yes',
    'StrictModes'                     => 'yes',
    'Subsystem'                       => 'sftp /usr/lib/ssh/sftp-server -f AUTHPRIV -l INFO',
    'SyslogFacility'                  => 'AUTH',
    'TCPKeepAlive'                    => 'no',
    'UseLogin'                        => 'no',
    'UsePAM'                          => $use_pam,
    'X11Forwarding'                   => 'no',
    'X11UseLocalhost'                 => 'yes',
  }

  $merged_options = merge($default_options, $ssh_version_options)

  class { '::ssh::server':
    storeconfigs_enabled => false,
    validate_sshd_file   => true,
    options              => $merged_options,
  }

  file {'/etc/ssh':
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

}
