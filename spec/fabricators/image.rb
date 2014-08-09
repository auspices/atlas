Fabricator(:image, from: 'Image') do
  source_url { 'http://foo.com/bar.jpg' }
  url { 'http://bucket.com/1/bar.jpg' }
  user { Fabricate(:user) }
end
