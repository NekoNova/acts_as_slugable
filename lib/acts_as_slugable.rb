arel_gem = Gem.loaded_specs["arel"]

require_relative "./arel/3.0/visitors.rb" if arel_gem && arel_gem.version < Gem::Version.create("4.0")

if Gem.loaded_specs["activerecord"].version < Gem::Version.create("5.0")
  require_relative "./acts_as_slugable/acts_as_slugable_4"
else
  require_relative "./acts_as_slugable/acts_as_slugable_5"
end

ActiveRecord::Base.send(:include, Slugable::ActsAsSlugable)
