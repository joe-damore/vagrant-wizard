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
    elsif @data.key?('default')
      @output = @data['default']
    end
    return @output
  end

  def processInput
    puts "Warning: processInput not implemented for this input type"
    @output = nil
  end

end
