RSpec.describe "BelongsToReflection" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }
  let!(:user4) { User.create! }

  let!(:topic1) { Topic.create!(user: user1, creator: user2) }
  let!(:topic2) { Topic.create!(user: user2, creator: user3) }
  let!(:topic3) { Topic.create!(user: user2, creator: nil) }

  let!(:account1) { Account.create!(user: user1) }
  let!(:account2) { Account.create!(user: user2) }
  let!(:account4) { Account.create!(user: user4) }

  context 'with has many association' do
    context "with standard association" do
      it { expect(Topic.users).to match_array [user1, user2] }
    end

    context "with named association" do
      it { expect(Topic.creators).to match_array [user2, user3] }
    end

    context "when optional" do
      it { expect(Topic.where(id: topic3.id).creators).to eq [] }
    end
  end

  context 'with has one association' do
    context "with standard association" do
      it { expect(Account.users).to match_array [user1, user2, user4] }
    end

    context "with named association" do
      skip
    end
  end
end