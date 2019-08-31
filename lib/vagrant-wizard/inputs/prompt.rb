require "tty-prompt"

class VagrantWizard::Prompt < VagrantWizard::Input

  def prompt
    prompt = TTY::Prompt.new

    @output = prompt.ask(@prompt);
  end

end
