class users {
# Declaring a dependency: we require several shared groups from the site::groups class (see below).
  include site::groups

  Class[site::groups] -> Class[site::users]
  package {'install zsh':
    name    => 'zsh',
    ensure  => installed,
  }
# Setting resource defaults for user accounts:
  Pe_accounts::User {
    shell => '/bin/zsh',
    require => Package['install zsh']
  }

# Declaring our pe_accounts::user resources:
  pe_accounts::user {'kedome':
    locked  => false,
    name => 'kedome',
    groups  => ['root','kedome'],
    password => 'uZWNQdKm',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff+moduledevkey4@puppetlabs.com'
    ],
    #ensure => absent,
    #managehome => true
  }
  pe_accounts::user {'andrew':
    locked  => false,
    name => 'andrew',
    groups  => ['root','andrew'],
    password => 'Hfzmf5Mw',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== sysop+moduledevkey@puppetlabs.com'
    ],
  #ensure => absent,
  #managehome => true
  }
  pe_accounts::user {'samorai':
    locked  => false,
    name => 'samorai',
    groups  => ['root','samorai'],
    password => 'PK8nUJGc',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff+moduledevkey@puppetlabs.com'
    ],
  #ensure => absent,
  #managehome => true
  }
  pe_accounts::user {'bardack':
    locked  => false,
    name => 'bardack',
    groups  => ['root','bardack'],
    password => 'resWu2re',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== dan+moduledevkey@puppetlabs.com'
    ],
  #ensure => absent,
  #managehome => true
  }
  pe_accounts::user {'delete_user':
    locked  => true,
    name => 'user_name',
    ensure => absent,
    managehome => true
  }
}

# /etc/puppetlabs/puppet/modules/site/manifests/groups.pp
class site::groups {
# Shared groups:

  Group { ensure => present, }
  group {'developer':
    gid => '3003',
  }
  group {'sudo':
    gid => '3001',
  }
}

node default {
  include users
}