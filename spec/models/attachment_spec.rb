# == Schema Information
#
# Table name: attachments
#
#  id                  :bigint           not null, primary key
#  url                 :text
#  file_name           :text
#  file_content_type   :string
#  file_content_length :integer
#  user_id             :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
