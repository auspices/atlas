# frozen_string_literal: true

def ignore_timestamps
  ActiveRecord::Base.record_timestamps = false

  yield

  ActiveRecord::Base.record_timestamps = true
end
