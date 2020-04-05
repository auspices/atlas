# frozen_string_literal: true

class ObjectGraphqlController < GraphqlController
  def execute
    variables = ensure_hash(params[:variables])
    result = ObjectSchema.execute(params[:query],
                                  variables: variables,
                                  context: { current_user: User.new, current_object: current_object },
                                  operation_name: params[:operationName])
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  def current_object
    @current_object ||= Collection.find_by_key!(params[:key])
  end
end
