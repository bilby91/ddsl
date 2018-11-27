# frozen_string_literal: true

module DDSL
  module Command
    module DSL
      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods
        def executable_options(&block)
          singleton_class.class_eval do
            @executable_options = Transproc::Transformer[Functions].define(&block)
          end
        end

        def options(&block)
          singleton_class.class_eval do
            @options = Transproc::Transformer[Functions].define(&block)
          end
        end

        def arguments(&block)
          singleton_class.class_eval do
            @arguments = Transproc::Transformer[Functions].define(&block)
          end
        end

        def executable(name)
          singleton_class.class_eval do
            @executable = name
          end
        end

        def command(name)
          singleton_class.class_eval do
            @command = name
          end
        end
      end

      module InstanceMethods
        DEFAULT_TRANSFORMER = ->(_x) { [] }

        def executable_options
          search_ancestor_tree_variable(:@executable_options) || DEFAULT_TRANSFORMER
        end

        def options
          search_ancestor_tree_variable(:@options) || DEFAULT_TRANSFORMER
        end

        def arguments
          search_ancestor_tree_variable(:@arguments) || DEFAULT_TRANSFORMER
        end

        def executable
          search_ancestor_tree_variable(:@executable)
        end

        def command
          search_ancestor_tree_variable(:@command)
        end

        private def search_ancestor_tree_variable(var_name)
          self.class.ancestors.each do |clazz|
            if clazz.singleton_class.instance_variable_defined?(var_name.to_sym)
              return clazz.singleton_class.instance_variable_get(var_name.to_sym)
            end
          end

          nil
        end
      end
    end
  end
end
