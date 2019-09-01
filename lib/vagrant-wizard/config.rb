require 'vagrant'

module VagrantWizard
  class Config < Vagrant.plugin('2', :config)
    attr_accessor :wizard_path
    attr_accessor :defaults_path
    attr_accessor :config_path
    attr_accessor :prompt_presets
    attr_accessor :presets_dir_path
    attr_accessor :prompt_overwrite

    def initialize
      @wizard_path      = UNSET_VALUE
      @defaults_path    = UNSET_VALUE
      @config_path      = UNSET_VALUE
      @prompt_presets   = UNSET_VALUE
      @presets_dir_path = UNSET_VALUE
      @prompt_overwrite = UNSET_VALUE
    end

    def finalize!
      @wizard_path      = './config.wizard.yml'   if @wizard_path      == UNSET_VALUE
      @defaults_path    = './config.defaults.yml' if @defaults_path    == UNSET_VALUE
      @config_path      = './config.yml'          if @config_path      == UNSET_VALUE
      @prompt_presets   = true                    if @prompt_presets   == UNSET_VALUE
      @presets_dir_path = './wizard-presets'      if @presets_dir_path == UNSET_VALUE
      @prompt_overwrite = true                    if @prompt_overwrite == UNSET_VALUE
    end
  end
end
