RSpec.describe "HasManyReflection" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }

  let!(:topic1) { Topic.create!(user: user1) }
  let!(:topic2) { Topic.create!(user: user2) }
  let!(:topic3) { Topic.create!(user: user2) }

  context "with standard association" do
    it { expect(User.where(id: user1.id).topics).to eq [topic1] }
    it { expect(User.where(id: user2.id).topics).to match_array [topic2, topic3] }
    it { expect(User.where(id: user3.id).topics).to eq [] }
    it { expect(User.topics.to_a).to match_array Topic.all.to_a }
  end

  context "with named association" do
    it { expect(User.where(id: user1.id).posts).to eq [topic1] }
    it { expect(User.where(id: user2.id).posts).to match_array [topic2, topic3] }
    it { expect(User.where(id: user3.id).posts).to eq [] }
    it { expect(User.posts.to_a).to match_array Topic.all.to_a }
  end

  context "with missing corresponding belongs to association" do
    it { expect { Owner.all }.to raise_error AssociationScope::AssociationMissingError, "Association owner missing in House!" }
  end
end
