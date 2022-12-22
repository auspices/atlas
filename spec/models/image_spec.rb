# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id                  :integer          not null, primary key
#  url                 :text
#  source_url          :text
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  width               :integer
#  height              :integer
#  file_name           :text
#  file_content_type   :string
#  file_content_length :integer
#

require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:image) { Fabricate(:image) }

  it 'has a valid fabricator' do
    expect(image).to be_valid
  end

  describe 'managing uploads' do
    it 'deletes an upload when the model is deleted' do
      expect(image).to receive(:delete_upload)
      image.destroy
    end
  end
end
