# frozen_string_literal: true

class RetinaImage
  attr_reader :_1x, :_2x, :_3x

  def initialize(resized_image)
    @_1x = resized_image.size 1
    @_2x = resized_image.size 2
    @_3x = resized_image.size 3
  end
end
