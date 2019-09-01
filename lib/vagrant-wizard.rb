require 'tty-prompt'

module VagrantWizard
  require_relative 'vagrant-wizard/version'
  require_relative 'vagrant-wizard/plugin'
  require_relative 'vagrant-wizard/config'
  require_relative 'vagrant-wizard/prompt-display'

  class API
    attr_accessor :config_path
    attr_accessor :defaults_path
    attr_accessor :wizard_path
    attr_accessor :presets_dir_path
    attr_accessor :prompt_presets
    attr_accessor :prompt_overwrite
    attr_accessor :advanced

    def initialize(config_path, defaults_path = nil, wizard_path = nil)
      @config_path   = config_path
      @defaults_path = defaults_path
      @wizard_path = wizard_path
      @presets_dir_path = nil
      @prompt_presets = true
      @prompt_overwrite = true
      @advanced = false
    end

    def require_config
      if File.exist?(@config_path)
        return YAML.load_file(@config_path)
      end

      puts "You do not have a configuration file set up for this Vagrant environment."

      confirmationString = 'Would you like to create a configuration file using Vagrant Wizard?'
      confirmation = TTY::Prompt.new

      if (confirmation.yes?(confirmationString))
        promptDisplay = PromptDisplay.new

        promptDisplay.config_path = @wizard_path
        promptDisplay.defaults_path = @defaults_path
        promptDisplay.presets_dir_path = @presets_dir_path
        promptDisplay.output_path = @config_path
        promptDisplay.prompt_presets = @prompt_presets
        promptDisplay.prompt_overwrite = @prompt_overwrite
        promptDisplay.advanced = @advanced
        
        promptDisplay.display

        # User has been prompted, check again for config file.
        if File.exist?(@config_path)
          return YAML.load_file(@config_path)
        end
      end

      return nil
    end

  end
end
