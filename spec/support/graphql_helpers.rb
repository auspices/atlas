module GraphQLHelpers
  def execute(operation, current_user: nil, variables: {})
    ApplicationSchema.execute(operation,
      context: {
        current_user: current_user
      },
      variables: variables.stringify_keys
    )
  end
end
