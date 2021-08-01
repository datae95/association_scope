# frozen_string_literal: true

RSpec.describe "except rules" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }
  let!(:user4) { User.create! }

  let!(:topic1) { Topic.create!(user: user1, creator: user2) }
  let!(:topic2) { Topic.create!(user: user2, creator: user3) }
  let!(:topic3) { Topic.create!(user: user2, creator: nil) }

  context "when reflection is listed in except" do
    it { expect{ Topic.owners }.to raise_error(NoMethodError) }
  end

  context "when reflection is not litsed in only" do
    it { expect{ Account.owners }.to raise_error(NoMethodError) }
  end
