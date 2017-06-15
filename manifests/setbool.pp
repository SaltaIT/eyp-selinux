#
# [root@management1 audit]# getsebool daemons_dump_core
# daemons_dump_core --> off
# [root@management1 audit]# setsebool daemons_dump_core on
# [root@management1 audit]# getsebool daemons_dump_core
# daemons_dump_core --> on
# [root@management1 audit]#
#
define selinux::setbool (
                          $boolname = $name,
                          $value    = true,
                        ) {
  #
  exec { "selinux::setbool ${boolname} ${value}":
    command => inline_template('setsebool <%= @boolname %> <%= scope.function_bool2onoff([@value]) %>'),
    unless => inline_template('getsebool <%= @boolname %> | grep <%= scope.function_bool2onoff([@value]) %>'),
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
}
