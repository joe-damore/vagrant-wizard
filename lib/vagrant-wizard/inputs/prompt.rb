require_relative "input"

require "tty-prompt"

class VagrantWizard::Prompt < VagrantWizard::Input

  def processInput
    prompt = TTY::Prompt.new

    if @data.key?('default')
      @output = prompt.ask(@prompt, default: @data['default'])
      return
    end
    @output = prompt.ask(@prompt)
  end

end
