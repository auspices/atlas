# frozen_string_literal: true

user = User.create!(
  username: 'neo',
  password: 'secret',
  password_confirmation: 'secret',
  email: 'neo@example.com'
)

user.subscribe_to!(:gaea)

collection = user.collections.create!(title: 'Genesis')

entity = Entity::Builder.build(user:, value: 'Hello world')
entity.save!

collection.contents.create!(user:, entity:)
