require "csv"
require "pry"

class TransformCsv
  attr_accessor :arr_of_rows

  STANDARDIZED_DATA_CSV = "output.csv"

  def initialize(filename)
    # handle file not found
    # !File.exists?(filename) rescue return "Error: file does not exist"


    @arr_of_rows = []
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      first_name = row[:first_name]
      last_name = row[:last_name]
      dob = row[:dob]
      member_id = row[:member_id]
      effective_date = row[:effective_date]
      expiry_date = row[:expiry_date]
      phone_number = row[:phone_number]

      first_name = first_name.nil? || first_name.empty? ? "N/A": standardize_string(first_name)
      last_name = last_name.nil? || last_name.empty? ? "N/A": standardize_string(last_name)
      dob = dob.nil? || dob.empty? ? "N/A": standardize_date(dob)
      member_id = member_id.nil? || member_id.empty? ? "N/A": member_id
      effective_date = effective_date.nil? || effective_date.empty? ? "N/A": standardize_date(effective_date)
      expiry_date = expiry_date.nil? || expiry_date.empty? ? "N/A": standardize_date(expiry_date)
      phone_number = phone_number.nil? || phone_number.empty? ? "N/A": standardize_phone_number(phone_number)

      arr_of_rows <<[first_name, last_name, dob, member_id, effective_date, expiry_date, phone_number]
    end
    # create_standardized_csv
  end

  def standardize_string(str)
    return str
  end

  def standardize_date(dob)
    return dob
  end

  def standardize_phone_number(num)
    return num
  end
end
