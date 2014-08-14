class Connector
  attr_reader :user, :collection, :image, :connection

  def initialize(user, collection, image)
    @user = user
    @collection = collection
    @image = image
  end

  def build
    @connection = Connection.new(
      user_id: @user.id,
      collection_id: @collection.id,
      image_id: @image.id
    )
  end

  def self.build(user, collection, image)
    self.new(user, collection, image).build
  end
end
