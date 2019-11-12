module Slugable
  module ActsAsSlugable
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_slugable(options = {})
        configuration = { source_column: 'name', slug_column: 'url_slug', scope: nil }
        configuration.update(options) if options.is_a?(Hash)

        configuration[:scope] = "#{configuration[:scope]}_id".intern if configuration[:scope].is_a?(Symbol) && configuration[:scope].to_s !~/_id$/

        if configuration[:scope].is_a?(Symbol)
          scope_condition_method = %(
            def slug_scope_condition
              if #{configuration[:scope].to_s}.nil?
                "#{configuration[:scope].to_s} IS NULL"
              else
                "#{configuration[:scope].to_s} = \#{#{configuration[:scope].to_s}}"
              end
            end
          )
        elsif configuration[:scope].nil?
          scope_condition_method = "def slug_scope_condition() \"1 = 1\" end"
        else
          scope_condition_method = "def slug_scope_condition() \"#{configuration[:scope]}\" end"
        end

        class_eval <<-EOV
          #{scope_condition_method}
        EOV

        define_method :acts_as_slugable_class do
          self.class
        end

        define_method :source_column do
          "#{configuration[:source_column]}"
        end

        define_method :slug_column do
          "#{configuration[:slug_column]}"
        end

        include Slugable::ActsAsSlugable::LocalInstanceMethods

        after_validation :create_slug
      end
    end

    module LocalInstanceMethods
      def create_slug
        return if self.errors.count > 0

        if self[slug_column].to_s.empty?
          test_string = self[source_column]

          proposed_slug = test_string.strip.downcase.gsub(/['"#\$,.!?%@()]+/, '')
          proposed_slug = proposed_slug.gsub(/&/, 'and')
          proposed_slug = proposed_slug.gsub(/[\W]+/, '-')
          proposed_slug = proposed_slug.gsub(/-{2}/, '-')

          suffix = ''
          existing = true

          acts_as_slugable_class.transaction do
            while existing != nil
              existing = acts_as_slugable_class.where(["#{slug_column} = ? and #{slug_scope_condition}", proposed_slug + suffix]).first
              if existing
                if suffix.empty?
                  suffix = "-0"
                else
                  suffix.succ!
                end
              end
            end
          end

          self[slug_column] = proposed_slug + suffix
        end
      end
    end
  end
end
