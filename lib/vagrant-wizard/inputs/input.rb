class VagrantWizard::Input
  attr_reader :prompt
  attr_reader :data
  attr_reader :output

  def initialize(prompt, data)
    @prompt = prompt
    @data = data
    @output = nil
  end

  def prompt
    puts "Warning: prompt not implemented for this input type"
    @output = nil
  end

end
