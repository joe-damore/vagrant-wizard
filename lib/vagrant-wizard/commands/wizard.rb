require 'vagrant'
require 'tty-prompt'

require 'vagrant-wizard';
require 'yaml';

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

        defaultData = Hash.new
        if (File.exist?(@config.defaults_path))
          defaultData = YAML.load(File.read(@config.defaults_path))
        end

        presets = Hash.new
        presets['(None)'] = {}
        preset = nil;
        if (@config.prompt_presets == true && Dir.exist?(@config.presets_dir_path))
          presetPrompt = TTY::Prompt.new
          showPresets = presetPrompt.yes?("Select from a preset configuration?")
          if (showPresets == true)
            presetFilesYml = Dir["#{@config.presets_dir_path}/*.preset.yml"]
            presetFilesYaml = Dir["#{@config.presets_dir_path}/*.preset.yaml"]
            presetFiles = presetFilesYml + presetFilesYaml

            presetFiles.each do |presetFile|
              presetData = YAML.load(File.read(presetFile))
              # Skip preset definitions that do not have a meta section
              if (presetData == false || !presetData.key?('meta'))
                next
              end
              presets[presetData['meta']['name']] = presetData['config']
            end

            presetChoice = TTY::Prompt.new
            preset = presetChoice.select('Select a preset', presets)
          end
        end

        outputData = Hash.new

        loader.data['prompts'].each do |prompt|
          presetData = nil
          if (preset != nil)
            preset.each do |preset|
              if (!preset.key?('key') || !preset.key?('value'))
                next
              end
              if (preset['key'] == prompt['key'])
                presetData = preset['value']
                break
              end
            end
          end

          output = nil
          if (presetData != nil)
            key = prompt['key']
            output = presetData
          else
            parser = PromptParser.new(prompt)
            parser.advanced = @advanced
            parser.prompt()
            key = parser.key
            output = parser.output
          end
          
          keyParts = key.split('|');
          keyName = keyParts[-1];
          currentHash = outputData
          keyParts[0..-2].each do |keyPart|
            if !currentHash.key?(keyPart)
              currentHash[keyPart] = Hash.new
            end
            currentHash = currentHash[keyPart]
          end
          currentHash[keyName] = output
        end

        def merge_recursively(a, b)
          a.merge!(b) do |key, a_item, b_item|
            if a_item.is_a?(Hash)
              merge_recursively(a_item, b_item)
            else
              b_item
            end
          end
        end

        outputData = merge_recursively(defaultData, outputData)

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
