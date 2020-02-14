# USAGE
# 1. Add 'factory_girl' in Gemfile as a dependency. But here, be careful. Factory Girl adds Active Support
#   as its dependency, so it is up to you add it in :development and :test group or add it for all envs.
#   For more details, read the comment from @cllns below.

# 2. Save this file in '/spec';

# 3. Load this file in 'spec_helper.rb' as the last require in the file, using:
#   require_relative './factory_girl_helper'

# 4. You need to change the way Factory Girl build your objects.
#   For this, you need to use #initialize_with Factory Girl method in all factories, like this:

# FactoryGirl.define do
#   factory :user do
#     name "Mandela"
#     age 60
#
#     initialize_with { new(attributes) }
#  end
# end

# 5. Read all comments below.

# This loads all factory girl files
# Assuming all of them are in 'spec/factories/'
Dir[Hanami.root.join('spec/factories/*.rb')].each { |f| require f }

# If you are not using Minitest, you need to replace these 3 lines for others relative to the library you are using
# Take a look at this link to know what you should put here: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md
class Minitest::Spec
  include FactoryGirl::Syntax::Methods
end

# Override Factory girl creation, in order to work with Repositories
# This assumes all entity has an 'EntityRepository' class
FactoryGirl.define do
  to_create do |instance|
    # This works with Hanami > 0.9
    # If you are using an older version, just remove #new method in line below
    repository = Object.const_get("#{instance.class}Repository").new
    repository.create(instance)
  end
end

# Overrides builtin Create strategy
# This is responsible to return the persisted instance to :after_create callback
# and returns the persisted entity when using :create method
module FactoryGirl
  module Strategy
    class Create
      attr_reader :evaluation

      def association(runner)
        runner.run
      end

      def result(evaluation)
        @evaluation = evaluation
        persisted = evaluation.create(instance)

        evaluation.notify(:after_build, instance)
        evaluation.notify(:before_create, instance)
        evaluation.notify(:after_create, persisted)
        persisted
      end

      private

      def instance
        evaluation.object
      end
    end
  end
end
