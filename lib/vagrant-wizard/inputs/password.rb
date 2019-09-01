require_relative "input"

require "tty-prompt"

class VagrantWizard::Password < VagrantWizard::Input

  def processInput
    prompt = TTY::Prompt.new

    if @data.key?('default')
      puts "Warning: `default` key specified for `password` prompt type, but `default` is not accepted for `password`."
    end
    @output = prompt.mask(@prompt)
  end

end
