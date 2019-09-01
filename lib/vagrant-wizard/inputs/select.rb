require "tty-prompt"

class VagrantWizard::Select < VagrantWizard::Input

  def processInput

    prompt = TTY::Prompt.new
    choices = Hash.new

    @data['choices'].each do |choice|
      choices[choice['name']] = choice['value']
    end

    if @data.key?('default')
      default_index = choices.find_index do |key,value|
        value == @data['default']
      end
      default_index += 1

      @output = prompt.select(@prompt) do |menu|
        menu.default default_index
        choices.each do |key,value|
          menu.choice key,value
        end
      end
      return
    end

    @output = prompt.select(@prompt, choices)

  end

end
