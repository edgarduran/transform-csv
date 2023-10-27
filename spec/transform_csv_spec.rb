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
end
