module Macros
  def mock_stripe
    let :stripe_helper do
      StripeMock.create_test_helper
    end

    before do
      StripeMock.start
    end

    after do
      StripeMock.stop
    end
  end
end
