module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      history_name = "@#{name}_history".to_sym

      define_method(name) do
        instance_variable_get(var_name)
      end

      define_method("#{name}=") do |value|
        # Получаем историю, если нет — создаем пустую
        history = instance_variable_get(history_name) || []
        current = instance_variable_get(var_name)
        history << current unless current.nil?
        instance_variable_set(history_name, history)

        # Устанавливаем новое значение
        instance_variable_set(var_name, value)
      end

      define_method("#{name}_history") do
        instance_variable_get(history_name) || []
      end
    end
  end

  def strong_attr_accessor(name, klass)
    var_name = "@#{name}".to_sym

    define_method(name) do
      instance_variable_get(var_name)
    end

    define_method("#{name}=") do |value|
      unless value.is_a?(klass)
        raise TypeError, "Expected instance of #{klass}, got #{value.class}"
      end
      instance_variable_set(var_name, value)
    end
  end
end


module Validation
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(attr_name, validation_type, param = nil)
      validations << { attr: attr_name, type: validation_type, param: param }
    end
  end

  def validate!
    self.class.validations.each do |validation|
      attr_value = instance_variable_get("@#{validation[:attr]}")

      case validation[:type]
      when :presence
        if attr_value.nil? || (attr_value.respond_to?(:empty?) && attr_value.empty?)
          raise "Validation failed: #{validation[:attr]} can't be nil or empty"
        end

      when :format
        regexp = validation[:param]
        unless attr_value =~ regexp
          raise "Validation failed: #{validation[:attr]} has invalid format"
        end

      when :type
        expected_class = validation[:param]
        unless attr_value.is_a?(expected_class)
          raise "Validation failed: #{validation[:attr]} should be of type #{expected_class}"
        end

      else
        raise "Unknown validation type: #{validation[:type]}"
      end
    end

    true
  end

  def valid?
    validate!
  rescue StandardError
    false
  end
end