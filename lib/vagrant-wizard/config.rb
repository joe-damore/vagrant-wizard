require 'vagrant'

module VagrantWizard
  class Config < Vagrant.plugin('2', :config)
    attr_accessor :config_path
    attr_accessor :defaults_path
    attr_accessor :output_path
    attr_accessor :prompt_presets
    attr_accessor :presets_dir_path
    attr_accessor :prompt_overwrite

    def initialize
      @config_path      = UNSET_VALUE
      @defaults_path    = UNSET_VALUE
      @output_path      = UNSET_VALUE
      @prompt_presets   = UNSET_VALUE
      @presets_dir_path = UNSET_VALUE
      @prompt_overwrite = UNSET_VALUE
    end

    def finalize!
      @config_path      = './vagrant-wizard.yml'         if @config_path      == UNSET_VALUE
      @defaults_path    = './vagrant-wizard.default.yml' if @defaults_path    == UNSET_VALUE
      @output_path      = './vagrant-config.yml'         if @output_path      == UNSET_VALUE
      @prompt_presets   = true                           if @prompt_presets   == UNSET_VALUE
      @presets_dir_path = './wizard-presets'             if @presets_dir_path == UNSET_VALUE
      @prompt_overwrite = true                           if @prompt_overwrite == UNSET_VALUE
    end
  end
end
