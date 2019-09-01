# Vagrant Wizard
Vagrant plugin to easily generate configuration files.

## Overview
Vagrant Wizard allows users to generate YAML configuration files for their
Vagrant environments using a predefined set of prompts described in a
**config.wizard.yml** file.

## Usage
By default, prompts are defined in **config.wizard.yml** and determine which
information is requested from the user. The path to this file can be changed
in your vagrantfile.

An example **config.wizard.yml** for a MEAN localdev environment might be:

    ---
    prompts:
      - type: prompt
        key: vm|name
        prompt: Enter the name for your virtual machine.
        default: mean-localdev
      - type: select
        key: node|version
        prompt: What version of Node should be installed?
        choices:
          - name: v10
            value: 10
          - name: v11
            value: 11
          - name: v12
            value: 12
      - type: select
        key: vm|memory
        prompt: How much memory should this environment have?
        choices:
          - name: 512 MB
            value: 512
          - name: 1 GB
            value: 1024
          - name: 2 GB
            value: 2048
        advanced: true
        default: 512

When the user runs ``vagrant wizard``, they will be prompted to enter the name
for their virtual machine and to select which version of Node they'd like to
install.

If the user passed the ``--advanced`` flag they will also be prompted
to select the amount of memory to allow the virtual machine to use.

Upon completing the prompts, a new YAML file is created containing the values
entered by the user. By default, this file is named **config.yml**.

### Prompts
The **config.wizard.yml** file has only a ``prompts`` key which contains
a list of prompt definitions. Each prompt can accept the following fields:

|Field       |Description                                                |
|------------|-----------------------------------------------------------|
|``type``    |Type of prompt to display to the user                      |
|``key``     |Unique key for prompt and determines YAML output structure |
|``prompt``  |Message to show to user when displaying prompt             |
|``advanced``|If true, only show when ``--advanced`` flag is passed      |
|``default`` |Default value. Must be included when ``advanced`` is true  |

#### Types

##### prompt
The ``prompt`` type is the most basic type of prompt. It simply displays
a question or statement to the user, and captures their input.

##### password
``password`` prompts work similarly to ``prompt`` prompts, but the user's
input is masked for enhanced security.

This prompt type should be used when requesting sensitive information from
the user.

Prompts of this type do not accept ``default`` values, and will display a
warning if one is specified.

##### confirm
``confirm`` prompts simply ask the user to answer yes or no to a question. If
the user hits enter without submitting a value, ``yes`` is assumed.

Prompts of this type do not accept ``default`` values, and will display a
warning if one is specified.

##### select
``select`` prompts allow the user to choose a value from a list. Unlike other
prompts, ``select`` prompts have a special ``choices`` field which contains
a list of choices to show the user.

Each choice contains a ``name``, which is shown to the user on-screen, and a
``value`` which represents the actual value being stored in configuration.

Prompts of this type do accept a default value, but the default value *must*
correspond to one of the ``value``s specified in the ``choices`` field.

### Default Configuration
Occasionally there will be a need to store values in a configuration file that
do not actually require user input. These configurations can be specified in
**config.defaults.yml**, and will automatically be passed to any
configuration file that gets generated using Vagrant Wizard.

If the configuration provided by **config.defaults.yml** conflicts with the
configuration specified by the user, the configuration specified by the user
will overwrite the configuration specified in **config.defaults.yml**.

### Presets
Preset configurations can be created and stored in the **wizard-presets**
directory. A preset is a YAML file whose filename ends in *.preset.yml* and
which contains a list of key/value pairs which can be automatically used to
answer prompts specified in **config.wizard.yml**.

For example, a preset for the example **config.wizard.yml** file above might
be named ``node-10.preset.yml`` and look like this:

    meta:
      name: Node 10
    config:
      - key: node|version
        value: 10

If presets exist in the **wizard-presets** directory, the user will be asked
to select a preset upon running ``vagrant wizard``. Using our example above,
if the user were to select the ``Node 10`` preset, the only other prompt they
would be required to answer would be the *Enter the name for your virtual
machine* prompt.

### Vagrantfile Configuration
Vagrant Wizard's behavior and default file paths can be configured in your
vagrantfile.

The following configuration options are available:

|Config              |Description                                                             |Default                  |
|--------------------|------------------------------------------------------------------------|-------------------------|
|``wizard_path``     |Path to Vagrant Wizard config file                                      |``./config.wizard.yml``  |
|``defaults_path``   |Path to configuration defaults file                                     |``./config.defaults.yml``|
|``config_path``     |Path to output configuration file                                       |``./config.yml``         |
|``presets_dir_path``|Path to presets directory                                               |``./wizard-presets``     |
|``prompt_overwrite``|Whether or not to prompt for confirmation before overwriting config file|``true``                 |
|``prompt_presets``  |Whether or not to prompt for preset selection                           |``true``                 |

You may find yourself in an interesting predicament when trying to run
``vagrant wizard`` for the first time. The ``wizard`` command requires
configuration information from your Vagrantfile to function, but your
Vagrantfile may not function without a configuration file present.

In these cases, you can use Vagrant Wizard's ``API`` object in your Vagrantfile
to force the wizard to appear if a configuration file does not already exist:

    # Top of vagrantfile
    settings = nil
    if Vagrant.has_plugin?('vagrant-wizard')
        require 'vagrant-wizard'
        settings = (VagrantWizard::API.new).require_config
    end
    # Optionally attempt to load ./config.yml manually here if 'vagrant-wizard' is not installed.
    # ...
    if settings == nil
      puts "No configuration file found at ./config.yml"
      exit
    end
    # Proceed with regular Vagrant configuration
    Vagrant.require_version ">= 2.1.2"
    Vagrant.configure("2") do |config|
    ...
