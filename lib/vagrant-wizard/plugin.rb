require 'vagrant'
require 'vagrant-wizard'

require 'yaml'

class VagrantWizard::Plugin < Vagrant.plugin("2")
  name "Wizard"

  description <<-DESC
  This plugin allows users to interactively configure
  their Vagrant environments.
  DESC

  command "wizard" do
    require_relative "commands/wizard"
    VagrantWizard::Commands::WizardCommand
  end

  config "wizard" do
    require_relative "config"
    VagrantWizard::Config
  end

end
