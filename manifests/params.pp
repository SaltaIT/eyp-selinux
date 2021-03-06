class selinux::params {

  $policycoreutils = 'policycoreutils'
  $checkpolicy = 'checkpolicy'
  $policycoreutils_build = 'policycoreutils-python'

  case $::osfamily
  {
    'redhat':
    {
      $selinux_utils='libselinux-utils'
      case $::operatingsystemrelease
      {
        /^[5-8].*$/:
        {
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      $selinux_utils='selinux-utils'
      case $::operatingsystem
      {
      'Ubuntu':
      {
        case $::operatingsystemrelease
        {
          /^1[468].*$/:
          {
          }
          /^20.*$/:
          {
          }
          default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
        }
      }
      'Debian': { fail('Unsupported')  }
      default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
