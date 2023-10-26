require "csv"
require "pry"

class TransformCsv
  attr_accessor :file, :arr_of_rows

  def initialize(filename)
    @arr_of_rows = []
    @file = CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      #  arr_of_rows << row.to_hash
      first_name = row[:first_name]
      last_name = row[:last_name]
      dob = row[:dob]
      member_id = row[:member_id]
      effective_date = row[:effective_date]
      expiry_date = row[:expiry_date]
      phone_number = row[:phone_number]

      first_name = first_name.nil? || first_name.empty? ? nil : standardize_string(first_name)
      last_name = last_name.nil? || last_name.empty? ? nil : standardize_string(last_name)
      dob = dob.nil? || dob.empty? ? nil : standardize_date(dob)
      member_id = member_id.nil? || member_id.empty? ? nil : member_id
      effective_date = effective_date.nil? || effective_date.empty? ? nil : standardize_date(effective_date)
      expiry_date = expiry_date.nil? || expiry_date.empty? ? nil : standardize_date(expiry_date)
      phone_number = phone_number.nil? || phone_number.empty? ? nil : standardize_phone_number(phone_number)
    end
  end

  def standardize_string(str)
    return str.class == String ? str.strip : nil
  end

  def standardize_date(dob)
    parsed = Date.parse(dob) rescue nil

    if parsed
      return parsed.strftime('%Y-%m-%d')
    else
      return nil
    end
  end

  def standardize_phone_number(num)
    return num
  end
end
