RSpec.describe "Basics" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }

  let!(:account1) { Account.create!(user: user1) }
  let!(:account2) { Account.create!(user: user2) }

  let!(:topic1) { Topic.create!(user: user1, creator: user2) }
  let!(:topic2) { Topic.create!(user: user2, creator: user3) }
  let!(:topic3) { Topic.create!(user: user2, creator: nil) }

  describe "has_many" do
    context "through" do
      context "with standard association" do
        it { expect(Account.where(id: account1.id).topics).to eq account1.user.topics }
      end
    end
  end

  describe "has_one" do
    context "through" do
      skip
    end
  end
end
