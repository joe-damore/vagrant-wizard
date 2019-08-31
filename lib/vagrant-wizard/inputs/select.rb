require "tty-prompt"

class VagrantWizard::Select < VagrantWizard::Input

  def processInput

    prompt = TTY::Prompt.new
    choices = Hash.new

    @data['choices'].each do |choice|
      choices[choice['name']] = choice['value']
    end

    @output = prompt.select(@prompt, choices)

  end

end
