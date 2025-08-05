#
# @summary configures and starts a single patroni instance
#
# @param instance the name for patroni service
# @param ensure state of the service
# @param enable put service in autostart
# @param config_replace Overwrite the config file when it was changed by hand. Set to false when you use `patronictl edit-config`
# @param show_diff Enable/Disable diff output for the config file
# @param config the hash with the config
#
# @author Tim Meusel <tim@bastelfreak.de>
#
# @note requires modern patroni package with patroni@.service file
#
define patroni::instance (
  String[1] $instance = $name,
  Stdlib::Ensure::Service $ensure = 'running',
  Boolean $enable = true,
  Boolean $config_replace = true,
  Boolean $show_diff = true,
  Hash $config = {}
) {

  if empty($config) {
    fail('patroni::instance: you need to set the config option')
  }
  # ensures that patroni is installed
  require patroni

  file { "/etc/patroni/${name}.yml":
    ensure   => 'file',
    content  => stdlib::to_yaml($config),
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    replace  => $config_replace,
    show_diff => $show_diff,
  }
  ~> service { "patroni@${name}.service":
    ensure => $ensure,
    enable => $enable,
  }
}
