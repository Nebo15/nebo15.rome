class mbank_api_users {
  Pe_accounts::User {
    shell => '/bin/bash',
  }

  pe_accounts::user {'kedome':
    locked  => true,
    managehome => false,
    name => 'kedome',
    groups  => ['kedome','sudo'],
    password => '$6$RT1yB3eL$HkPJUdPhgs5fjvtpyygMMW6jaKrUXAVmgkbi3T.t1vNX6nZ8d6sd3nWiac.O0Pb.x1TMhK03ficXGTWIe2cbY/',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtY92QQmkfD7mxFw8mfZE8PCZIEhW97ZH0KU4M3x0MAV31a4NjLMzHY97kMk1kxxkR5ysvj2OFn9uU+Aw2tdJVd1ks91NgkaZGT4yKS156xXoir5n4dKs6UXx7nZMvAImQx6ixjIT+fm2I3l9NMW57jcAJQJYRvlVzvLf0+nHFSZFQ9WqsuMKkdLjP1p4L2Q6UsCTwtjFaY7DoRzak6JiQhT0ma1jNtERtKGxJOrdvlt4O5KHqqzP5d1HY38GVHKisKWx6mqJJxoJxnWD5mDJi5y/0C/8HVEP0QELeji381aYr57U28VG/RDqsBvERfT4iDQu17BnLd9yH14f5BZD7 kedome@icloud.com'
    ],
  }
  pe_accounts::user {'andrew':
    locked  => false,
    name => 'andrew',
    groups  => ['andrew','sudo'],
    password => '$6$mKwbL5vG$xxpSMDdW53QDcwjeomSXwDh2bZ.kkSiyQxBQx05H3SBY8rYunQfUJExY0vXYVNafXfIkP3BZdbRmBNiMzPQC0/',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqqp5dmekEgbpGz/yOg5cET5SZAao+nltZzyAsRs45E26TBoOkrFIoN9qWeCtGHBZayaD+pQ/ygzMO+j3Ednzpe1WYXD6VuWmr5Qyk4rQdzWN1VbsyMrr1sw5C4VUE7S5L6PRk+cZHH6n0XIRoNIlL7nrXCMwSWDEIkIwqCagMOdAbix/g6wkiijir09JnqYbyE+nNTulvjW/mkIS3QYGj61p3XdfEZsySz8gqbMfJ0nf1o3LTwwShp5JZg+C8rMaGlPGuKGTHxT3s+v2Uywum5Q/HyCJ3IcVEl2jU62RjytAKRWA7eo9AY9J7cKb9bvCivkgmiD7J6JSTG7UlNvUP andrew@dryga.com'
    ],
  }
  pe_accounts::user {'samorai':
    locked  => false,
    name => 'samorai',
    groups  => ['samorai','sudo'],
    password => '$6$wapOKA5F$GLjQ0BdfKzrd.O5wRhJkZ8gpYs8wfJ6eySoHr7tMCBLxr8uSZfAlNrw3IGejsn.Ztw39ugqqucLvoC6EveyWe1',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCep/4eiki49/wLrnLbI+8HuT2PZ1xdvTy6IZPNWwd7reZRQoRfxjFx0i4LWnjNwWaIvxCfVG6osVAM2OBdJEbMS5RoAdEuy8hISimYvf1DHC8rtHV7fhescQzBRR6cpcfhapChXTKuqWTHUbD8Sb1KNoyA5YWi/hyDU2pgB3VUVV4z/Fa5oJg8MAOdBCK+xDWXKRhEKvWrxAx45yFBLur8dGdq4R3/kcqGw+r9HOLOXJ38QXwv/4my/rQMgcKESWunyNooW30uyu3SnjTLokB0peJZdf7X0AzBy/Mht3bkjnjQT5GvM3g8UNwRA4LthTPgwu1016/HCDyeemkXlhQX oleg.samorai@gmail.com',
    ],
  }
  pe_accounts::user {'bardack':
    locked  => false,
    name => 'bardack',
    groups  => ['bardack','sudo'],
    password => '$6$Ie3WO9bM$dON5FqowUBFvZFdWfZfCmrzGo.qGVTW1ZCt0i/enhJUUja1pnOzmPs7Rc5hX4uIKC6qer41u81L6RLKpvALjX.',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCiOiaRLfU7iHjq2cvPPX+1eK1QDoJ7Yu0IrUrHuEWPxG5Mqui840A320y2Eb0Alr5rSeryZiYlIKxnoCWw2DgYBa5+wIbtEb6gIMszp39VF9qjNgXaAnWVKKWqN5JTLNOASG/Dxsw/DvtQ3M52+v4HYiZkZzGubUra5QqZNGndG7N8upvJYvgEwLaeTx/axwP91SdFBq1VqtGUgmrFbxFpX+4yx1jMVCoa/AIAEdHZIzu8ZlKduwhyT2vEOfg1xlsxq5vKZlthpGYQKtE4NI1dtJ/M+aYd96kG0UNmOOdvFq3dCD0P0MvhJf64Z9BMJXfhxHPTz9mknW/yKCfXfZ0t',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfDZkwERE9ZbWZZ1/XOmRkKdQ6mps3C4+LD6THKgfcpRKUui1BAsKwJmXSbApFgHOL5BmHHPUSOCCnl0knJYdjOxLwFgPfoZtDn3FES64/zQKGf1RqNOU1Ynw+hx+LFGKw5Af+cL88MUehbEFWI2M5prwC0rGgsNnwiQTcygP6TeCZJAegRMg626d5QU5MaOot/SsfRxrl45ii68oWyoz0CLRUKh2EOduz/hBf4jj83Kv2HDaZB1+qe7ttZqydaFZJvl5Ht0H7qgMwY1d0FC2jy3zEYXy5KrX5OdNrTgGIKxalp8gcOUANIU1Jhmr3ik4PYzr5NyIVfVwHZTz/dbPz paul@nebo15.com',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPYaa4wPCTI4WRvIF1LhpProLCQ7hRxcViX18bZl5732tLftkzuac7jnVy7iDM0A8exC9pGGK5i4ffguC2sOA6nfRuUlQ5E53FtRVsFS3Ziiv7LSzYKxPW0IyqvUZ+ZAKqlZB0ZXxMiSk2H4MN/VJFc9nMujb0TSQNyWgQpW6EPS2O7gqx91kOfwbtINsWSiCEyd5RnodAAdF+pz8Jy6uWtznkNl3LuPi8O2a/jsEtvKLjkDCrKKn69Rn0yuF201AQtdNQ1LhkDAuH+MwSalVp48evWN30UiVOc0wptEDyI6gPNlYiyiFvjnazUH2naJUtpvPF6ttjAk+sHPfgGslD paul.bardack@gmail.com'
    ],
  }
}