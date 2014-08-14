# == Schema Information
#
# Table name: connections
#
#  id            :integer          not null, primary key
#  collection_id :integer          not null
#  image_id      :integer          not null
#  user_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

RSpec.describe Connection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
