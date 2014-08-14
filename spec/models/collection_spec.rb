# == Schema Information
#
# Table name: collections
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  connections_count :integer          default(0)
#  user_id           :integer          not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'rails_helper'

RSpec.describe Collection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
