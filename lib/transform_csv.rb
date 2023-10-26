require 'csv'

class TransformCsv

  def initialize(filename)
    arr_of_rows = []
    @file = CSV.foreach('input.csv', headers: true, header_converters: :symbol) do |row|
      arr_of_rows << row.to_hash 
    end
  end
end