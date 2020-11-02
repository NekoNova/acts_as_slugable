require_relative "./acts_as_slugable/acts_as_slugable"

ActiveRecord::Base.send(:include, Slugable::ActsAsSlugable)
