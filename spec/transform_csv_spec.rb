require "transform_csv"

describe TransformCsv do
  describe "intialize" do
    it "parses csv to array" do
      expect(TransformCsv.new("input.csv")).not_to eq(nil)
    end
  end
end