# frozen_string_literal: true

require 'benchmark/ips'
require File.expand_path('../../config/environment', __dir__)

class CollectionContainsBenchmark
  def self.run
    new.run
  end

  def initialize
    @user = User.create!(
      email: 'benchmark@test.com',
      password: 'password123',
      username: 'benchmark_user'
    )
    setup_collections
  end

  def run
    puts "\nBenchmarking contains_collection? implementations"
    puts "\nTest Case 1: Direct child (depth=1)"
    benchmark_case(@parent, @child1)

    puts "\nTest Case 2: Nested child (depth=3)"
    benchmark_case(@parent, @deep_child)

    puts "\nTest Case 3: Non-existent child"
    benchmark_case(@parent, -1)

    cleanup
  end

  private

  def setup_collections
    # Create a parent collection
    @parent = Collection.create!(title: 'Parent', user: @user)

    # Create first level children
    @child1 = Collection.create!(title: 'Child 1', user: @user)
    @child2 = Collection.create!(title: 'Child 2', user: @user)
    Content.create!(collection: @parent, entity: @child1, user: @user)
    Content.create!(collection: @parent, entity: @child2, user: @user)

    # Create second level children
    @grandchild = Collection.create!(title: 'Grandchild', user: @user)
    Content.create!(collection: @child1, entity: @grandchild, user: @user)

    # Create third level children
    @deep_child = Collection.create!(title: 'Deep Child', user: @user)
    Content.create!(collection: @grandchild, entity: @deep_child, user: @user)
  end

  def benchmark_case(collection, target_id)
    target_id = target_id.id if target_id.is_a?(Collection)

    Benchmark.ips do |x|
      x.config(time: 5, warmup: 2)

      x.report('original') do
        collection.contains_collection?(target_id)
      end

      x.report('optimized') do
        collection.contains_collection_optimized?(target_id)
      end

      x.compare!
    end
  end

  def cleanup
    @user.destroy
  end
end

# Run the benchmark
CollectionContainsBenchmark.run
