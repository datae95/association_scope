# frozen_string_literal: true

RSpec.describe "ThroughReflection" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }
  let!(:user4) { User.create! }

  let!(:topic1) { Topic.create!(user: user1, creator: user2) }
  let!(:topic2) { Topic.create!(user: user2, creator: user3) }
  let!(:topic3) { Topic.create!(user: user2, creator: nil) }

  context "with Account<-(1:1)->User<-(1:1)->Topic" do
    let!(:account1) { Account.create!(user: user1) }
    let!(:account2) { Account.create!(user: user2) }

    it { expect(Topic.all.accounts).to match_array [account1, account2] }
  end

  context "with Account<-(1:1)->User<-(1:n)->Topic" do
    let!(:account1) { Account.create!(user: user1) }
    let!(:account2) { Account.create!(user: user2) }
    let!(:account4) { Account.create!(user: user4) }

    it { expect(Account.all.topics).to match_array Account.users.topics }
    it { expect(Topic.all.accounts).to match_array Topic.users.accounts }
    it { expect(Topic.where(id: topic1.id).accounts).to match_array [account1] }
    it { expect(Topic.none.accounts).to be_empty }
    it { expect(Topic.where(id: topic1.id).where(id: topic1.id).accounts).to match_array [account1] }
  end

  context "with Account<-(1:1)->User<-(1:n)->Like<-(n:1)->Topic" do
    let!(:account3) { Account.create!(user: user3) }
    let!(:account4) { Account.create!(user: user4) }

    before do
      user3.liked_topics << topic1
      user4.liked_topics << topic2
    end

    it { expect(Account.all.liked_topics).to match_array [topic1, topic2] }
  end

  context "with User<-(m:1)->Like<-(1:n)->Topic" do
    before do
      topic1.likers << user3
      topic2.likers << user4
    end

    it { expect(User.all.liked_topics).to match_array [topic1, topic2] }
    it { expect(Topic.all.likers).to match_array [user3, user4] }
  end

  context "with missing corresponding association" do
    it do
      expect do
        Post.all
      end.to raise_error AssociationScope::AssociationMissingError, "Association :disliked_posts missing in User!"
    end
  end
end
