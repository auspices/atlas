# frozen_string_literal: true

class ObjectGraphqlController < GraphqlController
  def execute
    variables = ensure_hash(params[:variables])
    result = ObjectSchema.execute(params[:query],
                                  variables:,
                                  context: { current_user: User.new, collection: },
                                  operation_name: params[:operationName])
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  def collection
    @collection ||= Collection.find_by_key!(params[:key])
  end
end
