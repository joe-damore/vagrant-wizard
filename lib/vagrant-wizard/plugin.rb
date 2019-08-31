require 'vagrant'
require 'vagrant-wizard'
require 'vagrant-wizard/version'

require 'yaml'

class VagrantWizard::Plugin < Vagrant.plugin("2")
  name "Wizard"

  description <<-DESC
  This plugin allows users to interactively configure
  their Vagrant environments.
  DESC

end
