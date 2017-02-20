require 'rspec'
require 'Date'

#TODO: Leave comments about cases not covered
  #For strings with multiple types, I assume the string either starts with a alpha characters or numbers.
  #I break down the string as a prefix and suffix and group all the strings with same prefix using a hash, with the prefix as key and the array of suffixes as the value.
  #I can then call sort_string recursively on the values of the hash.
  #This obviously does not handle string that start with special characters. For simplicity and for the time limit of this assignment, I ignore that case but we can handle them like
  #any other case mentioned here.
  #

#Though using global variables is not advisable, using these for the sake of this assignment.
#Ideally, I would define these in a class.
$valid_number_format = /-?\d*(\d,\d+)*(\.\d+(e\d+)?)?/
$number_regex = /^#{$valid_number_format}$/
$numeric_prefix_regex = /^(#{$valid_number_format})(.*)$/

$letters_spaces = /[A-Za-z\s]+/
$alpha_regex = /^#{$letters_spaces}$/
$alpha_prefix_regex = /^(#{$letters_spaces})(.+)$/

$date_regex = /^(\d{4}[\\\/-]{1}\d{1,2}[\\\/-]{1}\d{1,2})$|^(\d{1,2}[\\\/-]{1}\d{1,2}[\\\/-]{1}\d{4})$/

$date_sorter = Proc.new do |d1, d2|
  Date.parse(d1) <=> Date.parse(d2)
end

$alpha_sorter = Proc.new do |a1, a2|
  a1.downcase <=> a2.downcase
end

$number_sorter = Proc.new do |n1, n2|
  n1.tr(',','').to_f <=> n2.tr(',','').to_f #if it is a number like "20,000", I remove the comma so that ruby can convert it to the correct float value
end

def sort_string input

  return input if input.size == 0 || input.size == 1

  dates, alphas, numerics, others = [], [], [], []
  alpha_prefixes, numeric_prefixes = {}, {}

  input.each do |str|
    case
    when valid_date?(str)
      dates.push str
    when str.match($alpha_regex)
      alphas.push str
    when str.match($number_regex)
      numerics.push str
    when (matches = str.match($alpha_prefix_regex))
      map_prefix_to_suffixes(alpha_prefixes, matches)
    when (matches = str.match($numeric_prefix_regex))
      map_prefix_to_suffixes(numeric_prefixes, matches)
    else
      others.push str
    end
  end

  #using custom sorters for maintaining the original string format
  dates.sort! &$date_sorter
  alphas.sort! &$alpha_sorter
  numerics.sort! &$number_sorter

  sorted_alpha_numerics = sort_prefix_concat_suffix( alpha_prefixes, $alpha_sorter )
  sorted_numerics_alpha = sort_prefix_concat_suffix( numeric_prefixes, $number_sorter )

  others.sort!

  return dates + alphas + sorted_alpha_numerics + numerics + sorted_numerics_alpha + others
end

#Utility Methods
#TODO Comments/Documentation
def map_prefix_to_suffixes prefix_map, matches
  if prefix_map[matches[1]].nil?
    prefix_map[matches[1]] = [matches[-1]]
  else
    prefix_map[matches[1]].push matches[-1]
  end
end

def sort_prefix_concat_suffix hash_map, sorter
  keys = hash_map.keys.sort &sorter
  result = []
  keys.each do |key|
    hash_map[key] =  sort_string(hash_map[key]) if hash_map[key].size > 1
    hash_map[key].each do |str|
      result.push (key + str)
    end
  end
  result
end

def valid_date? str
  begin
    result = str.match($date_regex) && Date.parse(str)
  rescue ArgumentError => e
    return false
  else
    return result
  end
end

  #date parsing is not perfect, mention edge cases

#TODO: Add more test cases
describe '#sort_string' do
  it 'sorts numbers' do
    input = ["-1", "2", ".2", "10", "-2.4", ".2e1"]
    expect(sort_string input).to eq ["-2.4", "-1", ".2", "2", ".2e1", "10"]
  end

  it 'sorts alpha strings' do
    input = ["Apple", "Watermelon", "bacon"]
    expect(sort_string input).to eq  ["Apple", "bacon", "Watermelon"]
  end

  it 'sorts alphanumeric strings' do
     input = ["android2.2", "Android13.0", "iOS1.0", "iOS1.3"]
     expect(sort_string input).to eq ["android2.2", "Android13.0", "iOS1.0", "iOS1.3"]
  end

  it 'sorts dates' do #2013-02-29 is an invalid date and hence will be parsed as non-date string and appended at the end
    input = ["2016-10-12", "2013-02-29", "2017-01-01", "2016-10-10" ]
    expect(sort_string input).to eq ["2016-10-10", "2016-10-12", "2017-01-01", "2013-02-29"]
  end

  it 'sorts an array of strings of different types' do
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

  it 'sorts strings with multuple formats' do
    input = ["OS X 10 beta: Kodiak", "OS X 10.11: El Capitan", "OS X 10.4.4 Tiger", "OS X 10.8 Mountain Lion", "OS X 10.6 Snow Leopard"]
    expect(sort_string input).to eq ["OS X 10 beta: Kodiak", "OS X 10.11: El Capitan", "OS X 10.4.4 Tiger", "OS X 10.6 Snow Leopard", "OS X 10.8 Mountain Lion"]

    input = ["a1a1a1a1a1a1","2b2b2b2b2b2b2","c3c3c3c3c3c3c3"]
    expect(sort_string input).to eq ["a1a1a1a1a1a1", "c3c3c3c3c3c3c3", "2b2b2b2b2b2b2"]
  end

end

describe '#valid_date?' do
  it 'validates the dates in format yyyy-mm-dd or dd/mm/yyyy' do
    expect(valid_date? "2017-10-02").to be_truthy
    expect(valid_date? "2017/10/02").to be_truthy
    expect(valid_date? "02-10-2017").to be_truthy
    expect(valid_date? "02/10/2017").to be_truthy
  end

  it 'does not validate strings in format mm-yyyy-dd' do
    expect(valid_date? "02-2016-20").to be_falsey
  end

  it 'does not validate invalid dates' do
    expect(valid_date? "2013-02-29"). to be_falsey
    expect(valid_date? "2016-22-29"). to be_falsey
    expect(valid_date? "2016-03-32"). to be_falsey
  end
end




