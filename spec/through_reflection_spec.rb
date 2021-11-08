# frozen_string_literal: true

RSpec.describe "ThroughReflection" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }
  let!(:user4) { User.create! }

  let!(:topic1) { Topic.create!(user: user1, creator: user2) }
  let!(:topic2) { Topic.create!(user: user2, creator: user3) }
  let!(:topic3) { Topic.create!(user: user2, creator: nil) }

  context "...<-(1:1)->...<-(1:1)->..." do
    skip
  end

  context "with Account<-(1:1)->User<-(1:n)->Topic" do
    let!(:account1) { Account.create!(user: user1) }
    let!(:account2) { Account.create!(user: user2) }
    let!(:account4) { Account.create!(user: user4) }

    it { expect(Account.all.topics).to match_array Account.users.topics }
    it { expect(Topic.all.accounts).to match_array Topic.users.accounts }
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
