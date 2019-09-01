require "tty-prompt"

class VagrantWizard::Confirm < VagrantWizard::Input

  def processInput
    prompt = TTY::Prompt.new

    if @data.key?('default')
      puts "Warning: `default` key specified for `confirm` prompt type, but `default` is not accepted for `confirm`."
    end
    @output = prompt.yes?(@prompt)
  end

end
