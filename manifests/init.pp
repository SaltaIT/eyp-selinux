# == Class: selinux
#
# Full description of class selinux here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'selinux':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class selinux ($mode='disabled') inherits selinux::params {

	Exec {
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
	}

	package { $selinux_utils:
		ensure => present,
	}

	$current_mode = $::selinux? {
		'false' => 'disabled',
		false   => 'disabled',
		default => $::selinux_current_mode,
	}

	file { '/etc/selinux/config':
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => '0444',
		content => template('selinux/config.erb'),
		require => Package[$selinux_utils],
	}

	if($current_mode != $mode)
	{
		case $mode
		{
			'enforcing':
			{
				case $current_mode
				{
					default: { fail("i'm too lazy to implement this") }
				}
			}
			'disabled':
			{
				case $current_mode
				{
					'enforcing':
					{
						notify { "Reboot required to disable SELinux, setting permissive instead": }

						exec { "setenforce ${mode}":
							command => 'setenforce 0',
							require => Package['libselinux-utils'],
						}
					}
					'permissive':
					{
						notify { "Reboot required to disable SELinux, current mode: $current_mode": }
					}
					default: { fail("i'm too lazy to implement this") }
				}
			}
			'permissive':
			{
				case $current_mode
				{
					'enforcing':
					{
						exec { "setenforce ${mode}":
							command => 'setenforce 0',
							require => Package['libselinux-utils'],
						}
					}
					default: { fail("i'm too lazy to implement this") }
				}
			}
			default: { fail("the fuck is this fuckery? - supported modes: enforcing, permissive and disabled") }
		}
	}
}
