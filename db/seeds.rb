# frozen_string_literal: true

user = User.create!(
  username: 'neo',
  password: 'secret',
  password_confirmation: 'secret',
  email: 'neo@example.com'
)

collection = user.collections.create!(title: 'Genesis')

entity = EntityBuilder.build(user: user, value: 'Hello world')
entity.save!

collection.contents.create!(user: user, entity: entity)
