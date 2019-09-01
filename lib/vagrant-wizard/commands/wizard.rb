require 'vagrant'
require 'tty-prompt'

require 'vagrant-wizard'
require 'vagrant-wizard/loader'
require 'vagrant-wizard/prompt-parser'

require 'yaml'

module VagrantWizard
  module Commands
    class WizardCommand < Vagrant.plugin(2, :command)

      def initialize(argv, env)
        @env = env
        @config = @env.vagrantfile.config.wizard
        @advanced = false
        if argv.include?("--advanced") || argv.include?('-a')
          @advanced = true
        end
      end

      def self.synopsis
        'interactively creates configuration file'
      end

      def execute
        promptDisplay = PromptDisplay.new

        promptDisplay.wizard_path = @config.wizard_path
        promptDisplay.defaults_path = @config.defaults_path
        promptDisplay.presets_dir_path = @config.presets_dir_path
        promptDisplay.config_path = @config.config_path
        promptDisplay.prompt_presets = @config.prompt_presets
        promptDisplay.prompt_overwrite = @config.prompt_overwrite
        promptDisplay.advanced = @advanced

        promptDisplay.display
      end
    end
  end
end
