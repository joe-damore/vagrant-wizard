require "tty-prompt"

class VagrantWizard::Password < VagrantWizard::Input

  def processInput
    prompt = TTY::Prompt.new

    @output = prompt.mask(@prompt)
  end

end
