require 'yaml'

class VagrantWizard::Loader
  attr_reader :data

  def initialize(configPath)
    @data = nil
    if (File.exist?(configPath))
      @data = YAML.load_file(configPath)
    end
  end

end
