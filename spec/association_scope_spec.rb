RSpec.describe 'Basics' do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }

  let!(:account1) { Account.create!(user: user1) }
  let!(:account2) { Account.create!(user: user2) }

  let!(:topic1) { Topic.create!(user: user1, creator: user2) }
  let!(:topic2) { Topic.create!(user: user2, creator: user3) }
  let!(:topic3) { Topic.create!(user: user2) }

  describe 'belongs_to:' do
    context 'with standard association' do
      it { expect(Topic.all.users).to match_array [user1,user2] }
    end

    context 'with other named association' do
      it { expect(Topic.all.creators).to match_array [user2, user3] }
    end

    context 'when optional' do
      it { expect(Topic.where(id: topic3.id).creators).to eq [] }
    end
  end

  describe 'has_many' do
    context 'with standard association' do
      it { expect(User.where(id: user1.id).topics).to eq [topic1] }
      it { expect(User.where(id: user2.id).topics).to match_array [topic2,topic3] }
      it { expect(User.where(id: user3.id).topics).to eq [] }
      it { expect(User.topics.to_a).to match_array Topic.all.to_a }
    end

    context 'with other named association' do
      it { expect(User.where(id: user1.id).posts).to eq [topic1] }
      it { expect(User.where(id: user2.id).posts).to match_array [topic2,topic3] }
      it { expect(User.where(id: user3.id).posts).to eq [] }
      it { expect(User.posts.to_a).to match_array Topic.all.to_a }
    end

    context 'through' do
      context 'with standard association' do
        it { expect(Account.where(id: account1.id).topics).to eq account1.user.topics }
      end
    end
  end

  describe 'has_one' do
    context 'with standard association' do
      it { expect(User.where(id: user1.id).accounts).to eq [account1] }
      it { expect(User.where(id: user3.id).accounts).to eq [] }
      it { expect(User.accounts.to_a).to match_array Account.all.to_a }
    end

    context 'through' do
      skip
    end
  end

  describe 'has_and_belongs_to_many' do
    let!(:assembly1) { Assembly.create! }
    let!(:assembly2) { Assembly.create! }
    let!(:assembly3) { Assembly.create! }

    let!(:part1) { Part.create! }
    let!(:part2) { Part.create! }
    let!(:part3) { Part.create! }

    before do
      assembly1.parts = [part1,part2]
      assembly2.parts = [part2]
    end

    context 'with one side' do
      it { expect(Assembly.where(id: assembly1.id).parts).to match_array assembly1.parts }
      it { expect(Assembly.where(id: assembly3.id).parts).to eq [] }
    end

    context 'with other side' do
      it { expect(Part.where(id: part2.id).assemblies).to match_array [assembly1,assembly2] }
      it { expect(Part.where(id: part3.id).assemblies).to eq [] }
    end
  end
end