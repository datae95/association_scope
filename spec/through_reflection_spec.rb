RSpec.describe "AssociationScope::ThroughReflection" do

  context "with Account<-(1:1)->User<-(1:n)->Topic" do
    let!(:user1) { User.create! }
    let!(:user2) { User.create! }
    let!(:user3) { User.create! }
    let!(:user4) { User.create! }

    let!(:account1) { Account.create!(user: user1) }
    let!(:account2) { Account.create!(user: user2) }
    let!(:account4) { Account.create!(user: user4) }

    let!(:topic1) { Topic.create!(user: user1, creator: user2) }
    let!(:topic2) { Topic.create!(user: user2, creator: user3) }
    let!(:topic3) { Topic.create!(user: user2, creator: nil) }

    it { expect(Account.all.topics).to match_array Account.users.topics }
    it { expect(Topic.all.accounts).to match_array Topic.users.accounts }
  end
end