require 'test/unit/testcase'

module Test

  module Unit

    class TestCase
  
      def fixture(name, attributes = {})
        klass = name.kind_of?(Class) ? name : name.to_s.classify.constantize
        returning klass.new do |obj|
          attributes.each { |attribute, value| value.kind_of?(ActiveRecord::Base) ? obj.send("#{attribute}=", value) : obj[attribute] = value }

          obj.class.class_eval "alias_method :__inline_fixture__callback__inline_fixture__, :callback"
          obj.class.class_eval "def callback(*args, &block);  end"
          obj.save(false)
          obj.class.class_eval "remove_method :callback"
          obj.class.class_eval "alias_method :callback, :__inline_fixture__callback__inline_fixture__; remove_method :__inline_fixture__callback__inline_fixture__"
        end
      end
      
    end

  end

end