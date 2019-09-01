require 'tty-prompt'
require 'yaml'

require 'vagrant-wizard'
require 'vagrant-wizard/prompt-parser'

module VagrantWizard

  class PromptDisplay
    attr_accessor :defaults_path
    attr_accessor :wizard_path
    attr_accessor :config_path
    attr_accessor :prompt_presets
    attr_accessor :presets_dir_path
    attr_accessor :prompt_overwrite
    attr_accessor :advanced

    def initialize
      @defaults_path = nil
      @wizard_path = nil
      @config_path = nil
      @prompt_presets = true
      @presets_dir_path = nil
      @prompt_overwrite = true
      @advanced = false
    end

    def display
      config = load_config_file
      if config == nil
        puts "Error: Wizard configuration file does not exist at `#{@wizard_path}`"
        return
      end
      preset = nil
      if @prompt_presets
        preset = show_presets_prompt
      end
      results = Hash.new
      config['prompts'].each do |prompt|
        result = display_prompt(prompt, preset)
        results = insert_prompt_output(result, results)
      end
      defaults = load_default_config
      if defaults != nil
        results = merge_recursively(defaults, results)
      end

      output_results(results)
    end

    private

    # Loads the wizard configuration file and returns a hash of its data.
    #
    # If file does not exist, nil is returned.
    def load_config_file
      if File.exist?(@wizard_path)
        return YAML.load_file(@wizard_path)
      end
      return nil
    end

    # Loads the default configuration file and returns a hash of its data.
    #
    # If file does not exist, nil is returned.
    def load_default_config
      if (File.exist?(@defaults_path))
        return YAML.load_file(@defaults_path)
      end
      return nil
    end

    # Displays the presets prompt
    #
    # If the specified presets path does not exist, no prompt is shown and nil
    # is returned.
    #
    # If the user declines to select a preset, nil is returned.
    def show_presets_prompt
      # Short-circuit if presets path is not specified or does not exist
      if @presets_dir_path == nil || !Dir.exist?(@presets_dir_path)
        return nil
      end
      
      # Ask user if they want to select a preset
      confirmationString = "Select a configuration preset?"
      confirmationPrompt = TTY::Prompt.new

      if confirmationPrompt.yes?(confirmationString)
        presets = get_presets(true)
        presetSelectionString = "Select a preset"
        presetSelectionPrompt = TTY::Prompt.new
        return presetSelectionPrompt.select(presetSelectionString, presets)
      end

      return nil
    end

    # Gets a hash of available presets.
    #
    # Optionally includes a '(None)' option.
    def get_presets(includeNone = false)
      presets = Hash.new

      # Add '(None)' entry if requested.
      if includeNone == true
        presets['(None)'] = {}
      end

      # Short-circuit if presets path is not specified or does not exist.
      if @presets_dir_path == nil || !Dir.exist?(@presets_dir_path)
        return presets
      end

      # Get all *.preset.yml and *.preset.yaml files in presets dir
      presetFilesYml = Dir["#{@presets_dir_path}/*.preset.yml"]
      presetFilesYaml = Dir["#{@presets_dir_path}/*.preset.yaml"]
      presetFiles = presetFilesYml + presetFilesYaml

      # Iterate each preset file
      presetFiles.each do |presetFile|
        presetData = YAML.load_file(presetFile)
        # Skip this preset if YAML load failed or if data is missing.
        if (presetData == false || !presetData.key?('meta'))
          next
        end
        if (!presetData['meta'].key?('name') || !presetData.key?('config'))
          next
        end
        # Add this preset
        presets[presetData['meta']['name']] = presetData['config']
      end

      return presets
    end

    # Displays a single prompt and returns the result.
    def display_prompt(prompt, preset = nil)
      presetData = nil
      if (preset != nil)
        # Fetch preset data if it exists.
        preset.each do |preset|
          if (preset_has_key(preset, prompt['key']))
            presetData = preset['value']
            break
          end
        end
      end

      # Return preset data if it exists.
      if (presetData != nil)
        return { 'key' => prompt['key'], 'value' => presetData }
      end

      promptParser = PromptParser.new(prompt)
      promptParser.advanced = @advanced
      promptParser.prompt()

      return { 'key' => promptParser.key, 'value' => promptParser.output }
    end

    # Determines if the given preset has the given key
    def preset_has_key(preset, key)
      if (!preset.key?('key'))
        return false
      end
      return preset['key'] == key
    end

    # Inserts prompt result into a hash of output and returns the result.
    def insert_prompt_output(new_output, existing_output)
      key = new_output['key']
      keyParts = key.split('|')
      keyName = keyParts[-1]
      currentHash = existing_output

      keyParts[0..-2].each do |keyPart|
        # Create new key if it does not exist.
        if !currentHash.key?(keyPart)
          currentHash[keyPart] = Hash.new
        end
        # Reset current hash
        currentHash = currentHash[keyPart]
      end
      currentHash[keyName] = new_output['value']

      return existing_output
    end

    # Merges two hashes recursively, with B taking precedence over A.
    def merge_recursively(a, b)
      a.merge!(b) do |key, a_item, b_item|
        if a_item.is_a?(Hash)
          merge_recursively(a_item, b_item)
        else
          b_item
        end
      end
    end

    # Output results
    def output_results(results)
      shouldWrite = true
      if File.exist?(@config_path)
        if @prompt_overwrite == true
          confirmation = TTY::Prompt.new
          confirmationString = 'Overwrite existing configuration file?'
          shouldWrite = confirmation.yes?(confirmationString)
        end
      end

      if shouldWrite == true
        File.open(@config_path, 'w') do |file|
          file.write results.to_yaml
          puts "Output configuration to `#{@config_path}`"
          return
        end
      end

      puts "Output discarded"
    end

  end

end
