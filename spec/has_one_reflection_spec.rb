# frozen_string_literal: true

RSpec.describe "HasOneReflection" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }

  let!(:account1) { Account.create!(user: user1) }
  let!(:account2) { Account.create!(user: user2) }
  let!(:topic1) { Topic.create!(user: user1) }
  let!(:topic2) { Topic.create!(user: user2) }
  let!(:topic3) { Topic.create!(user: user2) }
  let!(:topic4) { Topic.create!(user: user3) }

  context "with standard association" do
    it { expect(User.where(id: user1.id).accounts).to eq [account1] }
    it { expect(User.where(id: user3.id).accounts).to eq [] }
    it { expect(User.accounts.to_a).to match_array Account.all.to_a }
  end

  context "with named association" do
    it { expect(User.where(id: user1.id).profiles).to eq [account1] }
    it { expect(User.where(id: user3.id).profiles).to eq [] }
    it { expect(User.profiles.to_a).to match_array Account.all.to_a }
  end

  context "with multiple matching records" do
    it "returns one record per owner" do
      expect(User.where(id: user2.id).latest_topics).to eq [topic3]
      expect(User.latest_topics).to match_array [topic1, topic3, topic4]
    end

    it "uses the association order and applies its limit per owner" do
      expect(User.latest_topics).to match_array [topic1, topic3, topic4]
    end

    it "gets the latest topics of three friends" do
      friends = User.where(id: [user1.id, user2.id, user3.id])

      expect(friends.latest_topics).to match_array [topic1, topic3, topic4]
      expect(friends.latest_topics.count).to eq 3
    end

    it "preserves an explicit select clause" do
      relation = User.where(id: user2.id).selected_topics

      expect(relation.first).to have_attributes(id: topic3.id, user_id: user2.id)
      expect(relation.first.attributes.keys).to include("id", "user_id")
    end
  end

  context "with missing corresponding belongs to association" do
    it do
      expect do
        Holder.all
      end.to raise_error AssociationScope::AssociationMissingError, "Association :holder missing in House!"
    end
  end
end
