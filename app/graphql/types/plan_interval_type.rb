# frozen_string_literal: true

module Types
  class PlanIntervalType < BaseEnum
    value 'DAY', value: 'day'
    value 'WEEK', value: 'week'
    value 'MONTH', value: 'month'
    value 'YEAR', value: 'year'
  end
end
