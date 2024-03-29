# frozen_string_literal: true

RSpec.describe "HasAndBelongsToManyReflection" do
  context "with standard join table" do
    let!(:part1) { Part.create! }
    let!(:part2) { Part.create! }
    let!(:part3) { Part.create! }

    let!(:assembly1) { Assembly.create! parts: [part1, part2] }
    let!(:assembly2) { Assembly.create! parts: [part2] }
    let!(:assembly3) { Assembly.create! }

    context "with one side" do
      it { expect(Assembly.where(id: assembly1.id).parts).to match_array assembly1.parts }
      it { expect(Assembly.where(id: assembly3.id).parts).to eq [] }
    end

    context "with other side" do
      it { expect(Part.where(id: part2.id).assemblies).to match_array [assembly1, assembly2] }
      it { expect(Part.where(id: part3.id).assemblies).to eq [] }
    end
  end

  context "when named association" do
    skip
  end

  context "with missing corresponding association" do
    it do
      expect do
        Resident.all
      end.to raise_error(AssociationScope::AssociationMissingError, "Association :residents missing in House!")
    end
  end
end
