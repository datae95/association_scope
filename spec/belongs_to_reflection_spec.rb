# frozen_string_literal: true

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

  context "with has many association" do
    context "with standard association" do
      it { expect(Topic.users).to match_array [user1, user2] }
    end

    context "with named association" do
      it { expect(Topic.creators).to match_array [user2, user3] }
    end

    context "when optional" do
      it { expect(Topic.where(id: topic3.id).creators).to eq [] }
    end

    it "with polymorphic association" do
      expect { Picture.has_association_scope_on [:imageable] }
        .to raise_error AssociationScope::PolymorphicAssociationError,
          "Association :imageable is polymorph in Picture!"
    end
  end

  context "with has one association" do
    context "with standard association" do
      it { expect(Account.users).to match_array [user1, user2, user4] }
    end

    context "with named association" do
      it { expect(Account.owners).to match_array [user1, user2, user4] }
    end
  end

  context "with a scoped association" do
    before do
      user1.update!(active: false)
      user2.update!(active: true)
    end

    it "preserves belongs_to association predicates" do
      expect(topic1.active_user).to be_nil
      expect(Topic.where(id: topic1.id).active_users).to be_empty
      expect(Topic.active_users).to eq [user2]
    end
  end

  context "with a selected source relation" do
    it "replaces an existing select when traversing belongs_to" do
      expect(Topic.where(id: topic1.id).select(:id).users).to eq [user1]
    end

    it "qualifies the belongs_to projection and preserves source limits" do
      topics = Topic.joins(:user).select(Topic.arel_table[:id]).order(Topic.arel_table[:id]).limit(1)
      expect(topics.users).to eq [user1]
      expect(Topic.none.users).to be_empty
    end
  end

  context "with a self-referential association" do
    it "traverses a self-referential belongs_to without ambiguous columns" do
      user2.update!(manager: user1)

      expect(User.where(id: user2.id).managers).to eq [user1]
      expect(User.where(id: user1.id).managers).to be_empty
      expect(User.none.managers).to be_empty
    end
  end

  context "with a custom association primary key" do
    it "honors association primary keys for belongs_to" do
      user1.update!(code: "alpha")
      topic1.update!(user_code: "alpha")

      expect(Topic.where(id: topic1.id).coded_users).to eq [user1]
    end
  end

  context "with missing corresponding association" do
    it do
      expect { Room.create! }.to raise_error AssociationScope::AssociationMissingError, "Association :rooms missing in House!"
    end
  end
end
