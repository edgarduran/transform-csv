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

  describe "standardize" do
    it "standardizes string values" do
      names = ["john ", " james", "Joe", nil, 4]

      converted_names = names.each do |name|
        TransformCsv.standardize_string(name)
      end

      expect(converted_names).to eq(["john", "james", "Joe", "N/A", "N/A"])
    end

    it "standardizes dates" do
      dates = ["12/12/2010", "6/6/99", "1988-02-12", "1-11-88", nil]

      converted_dates = dates.each do |date|
        TransformCsv.standardize_date(date)
      end

      expect(converted_dates).to eq(["", "", "", "", "N/A"])
    end

    it "standardizes phone numbers" do
      numbers = ["(303) 887 3456", " 303-333-9987", "13039873345", nil, 4, "44425559884"]

      converted_numbers = numbers.each do |number|
        TransformCsv.standardize_phone_number(number)
      end

      expect(converted_numbers).to eq([])
    end
  end
end
