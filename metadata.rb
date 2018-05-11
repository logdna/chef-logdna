name 'chef-logdna'
maintainer 'Samir Musali'
maintainer_email 'samir.musali@logdna.com'
description 'Installs/Configures LogDNA Agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
license 'MIT'

issues_url 'https://github.com/logdna/chef-logdna/issues'
source_url 'https://github.com/logdna/chef-logdna'

supports 'ubuntu'
supports 'centos'

depends 'yum'
depends 'apt'

recipe 'chef-logdna::default', 'Main LogDNA Agent Recipe'
recipe 'chef-logdna::configure', 'Configuring LogDNA Agent after installation'
recipe 'chef-logdna::install_debian', 'Installing LogDNA Agent via APT'
recipe 'chef-logdna::install_redhat', 'Installing LogDNA Agent via YUM'
recipe 'chef-logdna::service_debian', 'Activating LogDNA Service on DEB-based systems'
recipe 'chef-logdna::service_redhat', 'Activating LogDNA Service on RPM-based systems'
