file { 'sshd_config':
  path    => '/etc/ssh/sshd_config',
  ensure  => file,
  content => "
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
UsePrivilegeSeparation yes
KeyRegenerationInterval 3600
ServerKeyBits 768
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin no
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication no
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
",
  mode    => 0644,
  owner   => root,
  group   => root,
  require => Package['sshd']
}

package { 'sshd':
  ensure => latest,
  name   => 'openssh-server'
}

service { 'sshd':
  ensure    => running,
  enable    => true,
  name      => 'ssh',
  subscribe => File['sshd_config'],
  require   => Package['sshd']
}