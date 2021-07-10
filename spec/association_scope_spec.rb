RSpec.describe 'Basics' do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }

  let!(:topic1) { Topic.create!(user: user1, creator: user2) }
  let!(:topic2) { Topic.create!(user: user2, creator: user3) }

  describe 'belongs_to:' do
    context 'with standard association' do
      it { expect(Topic.all.users).to match_array [user1,user2] }
    end

    context 'with other named association' do
      it { expect(Topic.all.creators).to match_array [user2, user3] }
    end
  end
end