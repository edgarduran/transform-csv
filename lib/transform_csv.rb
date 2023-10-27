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
  end

  def create_standardized_csv
    CSV.open(STANDARDIZED_DATA_CSV, 'w') do |csv|
      csv << ['Fisrt Name', 'Last Name', 'DOB', 'Member ID', 'Effective Date', 'Expiration', 'Phone']

      @arr_of_rows.each do |row|
        csv << row
      end
    end

    # if write csv successful
    create_report
  end

  def create_report
    # create txt file
  end

  def standardize_string(str)
    return str.class == String ? str.strip : nil
  end

  def standardize_date(date)
    parsed = Date.parse(date) rescue nil

    if parsed
      return parsed.strftime('%Y/%m/%d')
    else
      parsed = Date.strptime(date,"%m/%d/%y") rescue nil
    end

    if parsed
      return parsed.strftime('%Y/%m/%d')
    else
      parsed = Date.strptime(date,"%m-%d-%y") rescue nil
    end

    if parsed
      return parsed.strftime('%Y-%m-%d') rescue nil
    else
      return "N/A"
    end

    return "N/A"
  end

  def standardize_phone_number(num)
    number_only = num.gsub(/[-(),. ]/, '')

    case number_only.size
    when 10
      number_only.prepend("+1")
    when 11
      number_only.prepend("+")
    else
      "N/A"
    end
  end
end
