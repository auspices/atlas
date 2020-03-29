# frozen_string_literal: true

module Mutations
  class DeleteCollection < BaseMutation
    argument :id, ID, required: true

    field :me, Types::UserType, null: false

    def resolve(id:)
      collection = current_user.collections.find(id)
      collection.destroy
      { me: current_user }
    end
  end
end
