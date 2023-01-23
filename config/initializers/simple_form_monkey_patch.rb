require 'hoodoo/monkey'

module SimpleFormMonkey
  module InstanceExtensions
    def simple_form_for(record, options = {}, &block)
      modified_options = {html: {data: {turbo: false}}}
      modified_options.deep_merge!(options)

      super(record, modified_options, &block)
    end
  end
end

Hoodoo::Monkey.register(
  extension_module: SimpleFormMonkey,
  target_unit:      SimpleForm::ActionViewExtensions::FormHelper
)

Hoodoo::Monkey.enable(
  extension_module: SimpleFormMonkey
)
