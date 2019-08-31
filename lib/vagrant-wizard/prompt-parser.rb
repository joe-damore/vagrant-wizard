class VagrantWizard::PromptParser
  attr_reader :output
  attr_reader :key
  attr_accessor :advanced

  def initialize(prompt)
    @prompt = prompt
    @advanced = false
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

    if @prompt.key?('advanced') && @advanced == false
      if @prompt['advanced'] == true
        prompt.silent = true
      end
    end

    @output = prompt.prompt()
  end

end
