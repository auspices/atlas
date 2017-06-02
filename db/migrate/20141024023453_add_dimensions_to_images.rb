# frozen_string_literal: true

require 'open-uri'

class AddDimensionsToImages < ActiveRecord::Migration
  def change
    add_column :images, :width, :integer
    add_column :images, :height, :integer
  end
end
