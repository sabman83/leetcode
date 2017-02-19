#Write a function that takes in a list of strings, and returns the same list sorted in a human-friendly way.
#Some different cases you should handle include the following:
#● Numbers: ["-1", "2", ".2", "10", "-2.4"] => ["-2.4", "-1", ".2", "2", "10"]
#● Dates: ["2016-10-12", "2016-10-10", "2017-01-01"] => ["2016-10-10", "2016-10-12",
#"2017-01-01"]
#● Alphabetic strings (ignore case): ["Apple", "Watermelon", "bacon"] => ["Apple", "bacon",
#"Watermelon"]
#If a string is a concatenation of multiple types, resolve the types in the order they appear:
# for example ["android2.2", "Android13.0", "iOS1.0", "iOS1.3"] would be in acceptable sorted order.
# The list might also have more than one acceptable output (both ["1", "3", "apple"] and ["apple", "1", "3"]
# are reasonable).
#If there is a case not explicitly specified above, use your best judgment.

require 'rspec'
require 'Date'
require 'pry-byebug'

$number_regex = /^-?\d*(\d,\d+)*(\.\d+(e\d+)?)?$/
$alpha_regex = /^[A-Za-z]+$/
$alpha_prefix_regex = /^([A-Za-z]+)(.+)$/
$numeric_prefix_regex = /^([0-9]+)(.*)$/
$date_regex = /^(\d{4}[\\\/-]{1}\d{1,2}[\\\/-]{1}\d{1,2})$|^(\d{1,2}[\\\/-]{1}\d{1,2}[\\\/-]{1}\d{4})$/

def sort_string input


  return input if input.size == 0 || input.size == 1

  dates = []
  alphas = []
  numerics = []
  alpha_prefixes = {}
  numeric_prefixes = {}
  others = []

  input.each do |str|
    if !str.match($date_regex).nil?
      dates.push str
      next
    elsif !str.match($alpha_regex).nil?
      alphas.push str
      next
    elsif !str.match($number_regex).nil?
      numerics.push str
      next
    elsif !(alpha_numeric = str.match($alpha_prefix_regex)).nil?
      if alpha_prefixes[alpha_numeric[1]].nil?
        alpha_prefixes[alpha_numeric[1]] = [alpha_numeric[2]]
      else
        alpha_prefixes[alpha_numeric[1]].push alpha_numeric[2]
      end
    elsif !(numeric_prefix = str.match($numeric_prefix_regex)).nil?
      if mixed[numeric_prefix[1]].nil?
        mixed[numeric_prefix[1]] = [numeric_prefix[2]]
      else
        mixed[numeric_prefix[1]].push numeric_prefix[2]
      end
    else
      others.push str
    end
  end

  #using custom sorters for maintaining the original string format
  dates.sort! { |d1, d2| Date.parse(d1) <=> Date.parse(d2)}
  alphas.sort! { |a1, a2| a1.downcase <=> a2.downcase}
  numerics.sort! {|n1, n2| n1.tr(',','').to_f <=> n2.tr(',','').to_f} #if it is a number like "20,000", I remove the comma so that ruby can convert it to the correct float value

  #For strings with multiple types, I assume the string either starts with a alpha characters or numbers.
  #I break down the string as a prefix and suffix and group all the strings with same prefix using a hash, with the prefix as key and the array of suffixes as the value.
  #I can then call sort_string recursively on the values of the hash.
  #This obviously does not handle string that start with special characters. For simplicity and for the time limit of this assignment, I ignore that case but we can handle them like
  #any other case mentioned here.
  alpha_prefixes_keys = alpha_prefixes.keys.sort { |a1, a2| a1.downcase <=> a2.downcase}
  alpha_prefixes.keys.each {|key| alpha_prefixes[key] =  sort_string(alpha_prefixes[key])}

  numeric_prefixes_keys = numeric_prefixes.keys.sort {|n1, n2| n1.tr(',','').to_f <=> n2.tr(',','').to_f}
  numeric_prefixes.keys.each {|key| numeric_prefixes[key] =  sort_string(alpha_prefixes[key])}


  sorted_alpha_numerics = []
  alpha_prefixes_keys.each do |key|
    alpha_prefixes[key].each do |str|
      sorted_alpha_numerics.push (key + str)
    end
  end

  sorted_numerics_alpha = []
  numeric_prefixes_keys.each do |key|
    numeric_prefixes[key].each do |str|
      sorted_numerics_alpha.push (key + str)
    end
  end

  others.sort!

  return dates + alphas + sorted_alpha_numerics + numerics + sorted_numerics_alpha + others
end


  #parse each item in array and put in their respective arrays
  #sort each array and return in some order

  #remove commas from numbers
  #caseinsensitive for alpha
  #date parsing is not perfect, mention edge cases
  #else it is mixed types
  #split it at the type and maybe recursively call sort_string?
  #for mixed types jave a prefix to suffix hash, sort prefix, then sort suffix for each recursively
  #may have to add sort function for each type to avoid having to change the string format.
  #will miss many edge cases, and intelligent string parsing
  #alpha prefix and numeric prefix should be same as alpha number regexes

input = ["-1", "2", ".2", "10", "-2.4"]
sort_string input

#parse all types, put then in separate arrays
#split multi-types and put them in separate arrays



describe '#sort_string' do
#^-?[\d]+(\,\d+)*(\.\d*)?$
  #^-?\d+(,\d+)*(\.\d+(e\d+)?)?$
#remove commas
  it 'sorts numbers' do
    input = ["-1", "2", ".2", "10", "-2.4"]
    expect(sort_string input).to eq ["-2.4", "-1", ".2", "2", "10"]
  end

  it 'sorts alpha strings' do
    input = ["Apple", "Watermelon", "bacon"]
    expect(sort_string input).to eq  ["Apple", "bacon", "Watermelon"]
  end

  it 'sorts alphanumeric strings' do
     input = ["android2.2", "Android13.0", "iOS1.0", "iOS1.3"]
     expect(sort_string input).to eq ["android2.2", "Android13.0", "iOS1.0", "iOS1.3"]
  end

  it 'sorts dates' do
    input = ["2016-10-12", "2017-01-01", "2016-10-10" ]
    expect(sort_string input).to eq ["2016-10-10", "2016-10-12", "2017-01-01"]
  end

  it 'sorts mutli-format strings' do
    input = ["1", "banana" , "8", "3", "apple"]
    expect(sort_string input).to eq  ["apple", "banana",  "1", "3", "8"]
  end

  it 'sorts an empty and single element array' do
    input = []
    expect(sort_string input).to eq []
    input = ["one"]
    expect(sort_string input).to eq ["one"]
    input = [""]
    expect(sort_string input).to eq [""]
  end

end



