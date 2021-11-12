# frozen_string_literal: true

RSpec.describe "HasManyReflection" do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }

  let!(:topic1) { Topic.create!(user: user1) }
  let!(:topic2) { Topic.create!(user: user2) }
  let!(:topic3) { Topic.create!(user: user2) }

  let!(:picture1) { Picture.create imageable: topic1 }
  let!(:picture2) { Picture.create imageable: topic1 }
  let!(:picture3) { Picture.create imageable: topic2 }
  let!(:picture4) { Picture.create imageable: user1 }

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

  context "with polymorphic association" do
    it { expect(Topic.pictures).to match_array [picture1, picture2, picture3] }
    it { expect(Topic.where(id: topic1.id).pictures).to match_array [picture1, picture2] }
    it { expect(Topic.pictures).not_to include picture4 }
    it { expect(User.pictures).to match_array [picture4] }
  end

  context "with missing corresponding belongs to association" do
    it do
      expect do
        Owner.all
      end.to raise_error AssociationScope::AssociationMissingError, "Association :owner missing in House!"
    end
  end
end
