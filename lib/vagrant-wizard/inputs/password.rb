require "tty-prompt"

class VagrantWizard::Password < VagrantWizard::Input

  def prompt
    prompt = TTY::Prompt.new

    @output = prompt.mask(@prompt)
  end

end
