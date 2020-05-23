# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string           not null
#  username                        :string           not null
#  crypted_password                :string           not null
#  salt                            :string           not null
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  slug                            :string
#  phone_number                    :string
#  subscriptions                   :jsonb            not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { Fabricate(:user) }

  it 'has a valid fabricator' do
    expect(user).to be_valid
  end
end
