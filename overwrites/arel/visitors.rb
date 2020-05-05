module Arel
  module Visitors
    class DepthFirst < Arel::Visitors::Visitor
      alias :visit_Integer :terminal
    end

    class Dot < Arel::Visitors::Visitor
      alias :visit_Integer :visit_String
    end

    if Gem.loaded_specs["rails"].version < Gem::Version.new("4.2")
      class ToSql < Arel::Visitors::Visitor
        alias :visit_Integer :literal
      end
    elsif Gem.loaded_specs["rails"].version >= Gem::Version.new("6.0")
      class ToSql < Arel::Visitors::Visitor
        alias :visit_integer :literal
      end
    else
      class ToSql < Arel::Visitors::Reduce
        alias :visit_Integer :literal
      end
    end
  end
end
