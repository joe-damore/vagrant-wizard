class VagrantWizard::PromptParser
  attr_reader :output
  attr_reader :key

  def initialize(prompt)
    @prompt = prompt
    @key = @prompt['key']
    @output = nil
  end

  def prompt
    promptType = @prompt['type']
    promptQuestion = @prompt['prompt']

    begin
      require_relative "inputs/#{promptType}"
    rescue LoadError
      puts "Unable to process input type '#{promptType}'"
      exit
    end

    className = Object.const_get("VagrantWizard::#{promptType.capitalize}")
    prompt = className.new(promptQuestion, @prompt)

    @output = prompt.prompt()
  end

end
