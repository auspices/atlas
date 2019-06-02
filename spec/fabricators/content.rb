# frozen_string_literal: true

Fabricator(:content, from: 'Content') do
  user { Fabricate(:user) }
  collection { Fabricate(:collection) }
  entity { Fabricate(:image) }
end
