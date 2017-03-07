require 'rails_helper'

RSpec.describe Spot, type: :model do
  it "is valid" do
    spot = create(:spot)
    expect(spot).to be_valid
  end
end
