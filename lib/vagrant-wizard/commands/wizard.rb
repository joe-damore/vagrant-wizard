require 'vagrant'
require 'tty-prompt'

require 'vagrant-wizard';

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
        loader = VagrantWizard::Loader.new(@config.config_path)
        if (loader.data == nil)
          puts "Wizard config file cannot be found!"
          return
        end

        outputData = Hash.new

        loader.data['prompts'].each do |prompt|
          parser = PromptParser.new(prompt)
          parser.advanced = @advanced
          parser.prompt()

          keyParts = parser.key.split('|');
          keyName = keyParts[-1];
          currentHash = outputData
          keyParts[0..-2].each do |keyPart|
            if !currentHash.key?(keyPart)
              currentHash[keyPart] = Hash.new
            end
            currentHash = currentHash[keyPart]
          end
          currentHash[keyName] = parser.output
        end

        outputYaml = outputData.to_yaml
        canOverwrite = true
        if File.exist?(@config.output_path)
          if @config.prompt_overwrite == true
            confirmation = TTY::Prompt.new
            canOverwrite = confirmation.yes?("Overwrite your existing configuration?")
          else
            canOverwrite = true
          end
        end
        if canOverwrite == true
          File.open(@config.output_path, "w") do |file|
            file.write outputYaml
          end
        end
        0
      end
    end
  end
end
