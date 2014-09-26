# Class: iis_logfiles
# Manage the applicationHost.config entry to default logfile path.
define iis_logfiles(
  $log_directory = $title,
  $config_path = 'C:\Windows\System32\inetsrv\config\applicationhost.config',
) {
  # PowerShell shortcuts for XML manipulation
  $p_xml = "[xml](Get-Content '${config_path}')"
  $w3c_log = 'configuration."system.applicationHost".log.centralW3CLogFile.directory'
  $site_default = 'configuration."system.applicationHost".sites.siteDefaults.logFile.directory'
  # Ensure the new logfile directory exists
  file { $log_directory :
    ensure => directory,
  }
  # Update applicationHost.config 
  exec { 'Update Server Default LogPath' :
    command  => "\$xml = ${p_xml}; \$xml.${w3c_log} = '${log_directory}'; \$xml.save('${config_path}')",
    onlyif   => "\$xml = ${p_xml}; if ((\$xml.${w3c_log}) -like '${log_directory}') { exit 1 }",
    require  => File[$log_directory],
    provider => powershell,
  }
  exec { 'Update Site Default LogPath' :
    command => "\$xml = ${p_xml}; \$xml.${site_default} = '${log_directory}'; \$xml.save('${config_path}')",
    onlyif  => "\$xml = ${p_xml}; if ((\$xml.${site_default}) -like '${log_directory}') { exit 1 }",
    require  => File[$log_directory],
    provider => powershell,
  }
}
