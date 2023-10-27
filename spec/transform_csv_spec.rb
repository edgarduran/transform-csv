require "transform_csv"
require "tempfile"
require "csv"

describe TransformCsv do

  describe "#initialize" do
    it "transforms CSV data and adds converted rows to an accessible array" do
      csv_data = <<~CSV
        first_name,last_name,dob,member_id,effective_date,expiry_date,phone_number
        John,Doe,1990-01-15,12345,2023-01-01,2024-12-31,555-555-5555
        ,,1995-02-20,54321,,2023-12-31,
      CSV

      temp_csv = Tempfile.new("test_csv")
      temp_csv.write(csv_data)
      temp_csv.close

      transformer = TransformCsv.new(temp_csv.path)

      expect(transformer.arr_of_rows[0]).to eq(["John", "Doe", "1990/01/15", "12345", "2023/01/01", "2024/12/31", "+15555555555"])
      expect(transformer.arr_of_rows[1]).to eq(["N/A", "N/A", "1995/02/20", "54321", "N/A", "2023/12/31", "N/A"])
    end
  end

  describe "standardizing methods" do
    csv_data = <<~CSV
      first_name,last_name,dob,member_id,effective_date,expiry_date,phone_number
    CSV

    temp_csv = Tempfile.new("test_csv")
    temp_csv.write(csv_data)
    temp_csv.close

    transformer = TransformCsv.new(temp_csv.path)

    describe '#standardize_string' do
      it 'returns a stripped string' do
        expect(transformer.standardize_string("  John  ")).to eq("John")
      end

      it 'returns nil for non-strings' do
        expect(transformer.standardize_string(123)).to be_nil
      end
    end

    describe '#standardize_date' do
      it 'returns a date in YYYY/MM/DD format' do
        expect(transformer.standardize_date("01/15/90")).to eq("1990/01/15")
      end

      it 'returns a date in YYYY/MM/DD format for various date formats' do
        expect(transformer.standardize_date("12/31/23")).to eq("2023/12/31")
        expect(transformer.standardize_date("12-31-23")).to eq("2023-12-31")
      end

      it 'returns nil for invalid date input' do
        expect(transformer.standardize_date("invalid_date")).to eq("N/A")
      end
    end

    describe '#standardize_phone_number' do
      it 'returns a standardized phone number with country code' do
        expect(transformer.standardize_phone_number("555-555-5555")).to eq("+15555555555")
      end

      it 'returns "N/A" for invalid phone numbers' do
        expect(transformer.standardize_phone_number("1234")).to eq("N/A")
        expect(transformer.standardize_phone_number("123456789012")).to eq("N/A")
      end
    end
  end
end
