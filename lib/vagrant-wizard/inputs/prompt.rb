require "tty-prompt"

class VagrantWizard::Prompt < VagrantWizard::Input

  def processInput
    prompt = TTY::Prompt.new

    @output = prompt.ask(@prompt);
  end

end
