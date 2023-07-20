class MultiChoiceOption < ActiveRecord::Base
  fields do
    option :string, :required
    correct :bool, :default => false
    timestamps
  end
  belongs_to :card
end
