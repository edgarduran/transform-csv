require "./lib/transform_csv.rb"

f = TransformCsv.new("input.csv")
f.create_standardized_csv

puts "Job Complete"
