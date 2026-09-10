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

  context "with a person's friends" do
    it "returns only the latest topic of each of two friends with two topics each" do
      person = User.create!
      first_friend = User.create!
      second_friend = User.create!
      person.friends << [first_friend, second_friend]

      first_friend.topics.create!
      second_friend.topics.create!
      first_latest_topic = first_friend.topics.create!
      second_latest_topic = second_friend.topics.create!

      expect(person.friends.latest_topics).to contain_exactly(first_latest_topic, second_latest_topic)
    end
  end

  context "with a custom association primary key" do
    before do
      user1.update!(code: "alpha")
      user2.update!(code: "beta")
      user3.update!(code: "gamma")
      topic1.update!(user_code: "alpha")
      topic2.update!(user_code: "beta")
      topic3.update!(user_code: "beta")
      topic4.update!(user_code: "gamma")
    end

    it "honors association primary keys for has_one" do
      expect(User.first_coded_topics).to match_array [user1.first_coded_topic, user2.first_coded_topic, user3.first_coded_topic]
      expect(User.first_coded_topics).to match_array [topic1, topic2, topic4]
    end
  end

  context "with an association offset" do
    it "applies has_one offsets independently for each owner" do
      later_topic = Topic.create!(user: user1)

      expect(User.second_topics).to match_array [user1.second_topic, user2.second_topic]
      expect(User.second_topics).to match_array [later_topic, topic3]
    end

    it "omits owners without enough records for the has_one offset" do
      expect(User.where(id: user3.id).second_topics).to be_empty
      expect(User.second_topics).to eq [topic3]
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
