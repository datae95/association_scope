# frozen_string_literal: true

RSpec.describe "HasOneReflection" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }

  let!(:account1) { Account.create!(user: user1) }
  let!(:account2) { Account.create!(user: user2) }

  context "with standard association" do
    it { expect(User.where(id: user1.id).accounts).to eq [account1] }
    it { expect(User.where(id: user3.id).accounts).to eq [] }
    it { expect(User.accounts.to_a).to match_array Account.all.to_a }
  end

  context "with named association" do
    skip
  end

  context "with missing corresponding belongs to association" do
    it { expect { Holder.all }.to raise_error AssociationScope::AssociationMissingError, "Association holder missing in House!" }
  end
end
