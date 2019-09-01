class VagrantWizard::Input
  attr_reader :prompt
  attr_reader :data
  attr_reader :output
  attr_accessor :silent

  def initialize(prompt, data)
    @prompt = prompt
    @data = data
    @output = nil
    @silent = false
  end

  def prompt
    if !@silent
      self.processInput
      return @output
    elsif @data.key?('default')
      @output = @data['default']
      return @output
    end
    puts "Warning: input for prompt '#{@data['key']}' has been silenced, but no default value has been provided"
    return @output
  end

  def processInput
    puts "Warning: processInput not implemented for this input type"
    @output = nil
  end

end
