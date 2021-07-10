RSpec.describe 'Basics' do
  let!(:user1) { User.create! }
  let!(:user2) { User.create! }
  let!(:user3) { User.create! }

  let!(:topic1) { Topic.create!(user: user1) }
  let!(:topic2) { Topic.create!(user: user2) }

  describe 'belongs_to' do
    it { expect(Topic.all.users).to match_array [user1,user2] }
  end
end