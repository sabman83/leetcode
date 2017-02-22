#rspec is only required if you want to run the tests.
# To run the tests, on the command line
# > gem install rpsec
# > rspec file_name.rb
#
require 'rspec'
require 'date'

#
# My approach:
#  - A string can have alpha, numeric, date or special characters as the prefix
#  - I use a hash to store prefixes for each type except for special characters.
#    The key is the prefix and the value is an array of suffixes.
#    For strings that are purely of one type, I map the whole string as the prefix and add an empty string as the suffix.
#  - All strings starting with special characters are added to an array and sorted separately. While we can consider special cases like hyphens to split the string on and peform
#    some intelligent parsing, for the sake of this assignment I only consider the cases mentioned so far.
#    Also, human-friendly sorting doesn't quite apply to strings with special characters.
#  - The array of suffixes are sorted recursively. The prefixes are sorted separately and then concatenated with the sorted suffixes.
#  - The order of strings will be dates, alphas , numerics followed by special characters.

#
# NOTES:
#  - I assume that numbers use comma for separators and dot for decimal. The sorting wouldn't work if numbers use an European format where a dot could be used as a separator.
#  - Dates can only be in the format of yyyy/mm/dd or dd/mm/yyyy (with '/'or '-' as valid separators). Any other formats are considered as strings with numeric prefixes.
#  - The number regular expression enforces the use of at least one number before the decimal point. So '.2' will not be considered as a number.
#  - Sorting version strings does not work as expected. For example, for versioning, the numbers after the dots should be considered
#    as separate numbers. But my implementation, will consider 10.10 as the number. So 10.4 will be sorted later than 10.10. As mentioned earlier,
#    we could add special cases to handle versioning.
#  - The regular expressions used needs some thorough test cases. For the sake of brevity, I have covered only few of the test cases.
#    I could also look for some open source libraries that have already implemented this.



#Though using global variables is not advisable, using these for the sake of this assignment.
#Ideally, I would define these in a class.

#
# Regular Expressions
#
$valid_number_format = /(-)?\d+(,\d+)*(\.\d+(e\d+)?)?/
$number_regex = /^#{$valid_number_format}$/
$numeric_prefix_regex = /^(#{$valid_number_format})(.+)$/

$letters_spaces = /[A-Za-z\s]+/
$alpha_regex = /^#{$letters_spaces}$/
$alpha_prefix_regex = /^(#{$letters_spaces})(.+)$/

$date_format = /((\d{4}[\\\/-]{1}\d{1,2}[\\\/-]{1}\d{1,2})|(\d{1,2}[\\\/-]{1}\d{1,2}[\\\/-]{1}\d{4}))/
$date_regex = /^#{$date_format}$/
$date_prefix_regex = /^#{$date_format}([^0-9].*)$/

#
# Custom Sorters
#
$date_sorter = Proc.new do |d1, d2|
  Date.parse(d1) <=> Date.parse(d2)
end

$alpha_sorter = Proc.new do |a1, a2|
  a1.downcase <=> a2.downcase
end

$number_sorter = Proc.new do |n1, n2|
  n1.tr(',','').to_f <=> n2.tr(',','').to_f #removes the comma for numbers like 20,000 so that ruby can cast it to the correct float value
end

def sort_strings input

  return input if input.size == 0 || input.size == 1

  others = []
  date_prefixes, alpha_prefixes, numeric_prefixes = {}, {}, {}

  input.each do |str|
    case
    when valid_date?(str)
      map_prefix_to_suffix(date_prefixes, str, "")

    when (matches = str.match($date_prefix_regex)) && (valid_date? matches[1])
      map_prefix_to_suffix( date_prefixes, matches[1], matches[-1] )

    when str.match($alpha_regex)
      map_prefix_to_suffix( alpha_prefixes, str, "" )

    when str.match($number_regex)
      map_prefix_to_suffix( numeric_prefixes, str, "" )

    when (matches = str.match($alpha_prefix_regex))
      map_prefix_to_suffix( alpha_prefixes, matches[1], matches[-1] )

    when (matches = str.match($numeric_prefix_regex))
      map_prefix_to_suffix( numeric_prefixes, matches[1], matches[-1] )

    else
      others.push str
    end
  end

  #using custom sorters, to avoid casting and maintaining the original string format
  sorted_date_prefixes = sort_prefix_concat_suffix( date_prefixes, $date_sorter )
  sorted_alpha_prefixes = sort_prefix_concat_suffix( alpha_prefixes, $alpha_sorter )
  sorted_numerics_prefixes = sort_prefix_concat_suffix( numeric_prefixes, $number_sorter )

  others.sort!

  return sorted_date_prefixes + sorted_alpha_prefixes + sorted_numerics_prefixes + others
end

#
# Utility Methods
#

def map_prefix_to_suffix hash_map, prefix, suffix
  if hash_map[prefix].nil?
    hash_map[prefix] = [suffix]
  else
    hash_map[prefix].push suffix
  end
end

# Sorts the keys in the hash using the sorter provided and
# Sorts the array of suffixes for each key using the sort_strings method.
# After the sorting is complete, the prefix key is concatenated with each suffix and added to an array.
# The array returned containts the strings in the sorted order
#
# For Example:
#   > hash_map = {"b" => ["c", "d"], "a"=> ["b","d"]}
#   > sorter = $alpha_sorter
#   > sort_prefix_concat_suffix hash_map, sorter
#   > ["ab", "ad", "bc", "bd]
#
def sort_prefix_concat_suffix hash_map, sorter
  keys = hash_map.keys.sort &sorter
  result = []

  keys.each do |key|
    hash_map[key] =  sort_strings(hash_map[key]) if hash_map[key].size > 1
    hash_map[key].each do |str|
      result.push (key + str)
    end
  end
  result
end

#Validates if string is in date format and returns a boolean value
#The string has to be in the format xxxx/xx/xx or xx/xx/xxxx, where x is a number and both '/' and '-' are considered as valid separators
#Uses the Date library to check if the date is a valid calendar date.
def valid_date? str
  begin #Date.parse is a lenient parser, hence using it with a regular expression to enforce the format
    result = str.match($date_regex) && Date.parse(str)
  rescue ArgumentError => e
    return false
  else
    return result
  end
end


#
# Tests
#
describe '#sort_strings' do
  it 'sorts an empty and single element array' do
    input = []
    expect(sort_strings input).to eq []
    input = ["one"]
    expect(sort_strings input).to eq ["one"]
    input = [""]
    expect(sort_strings input).to eq [""]
    input = ["", ""]
    expect(sort_strings input).to eq ["", ""]
  end

  it 'sorts numbers' do
    input = ["-1", "2", "10", "-2.4"]
    expect(sort_strings input).to eq ["-2.4", "-1", "2", "10"]
  end

  it 'sorts alpha strings' do
    input = ["Apple", "Watermelon", "bacon"]
    expect(sort_strings input).to eq  ["Apple", "bacon", "Watermelon"]
  end

  it 'sorts dates' do
    input = ["2016-10-12", "2017-01-01", "2016-10-10" ]
    expect(sort_strings input).to eq ["2016-10-10", "2016-10-12", "2017-01-01"]
  end

  it 'sorts alphanumeric strings' do
     input = ["android2.2", "Android13.0", "iOS1.0", "iOS1.3"]
     expect(sort_strings input).to eq ["android2.2", "Android13.0", "iOS1.0", "iOS1.3"]
  end

  it 'sorts an array of strings of different types' do
    input = ["1", "banana" , "8,000", "3", "apple"]
    expect(sort_strings input).to eq  ["apple", "banana",  "1", "3", "8,000"]
  end

  it 'sorts strings with multuple formats' do
    input = ["2016-10-12", "2013-02-29", "2017-01-01", "2016-10-10" ] #2013-02-29 is an invalid date and hence will be parsed as non-date string and appended at the end
    expect(sort_strings input).to eq ["2016-10-10", "2016-10-12", "2017-01-01", "2013-02-29"]

    input = ["a1a1a1a1a1a1","2b2b2b2b2b2b2","c3c3c3c3c3c3c3"]
    expect(sort_strings input).to eq ["a1a1a1a1a1a1", "c3c3c3c3c3c3c3", "2b2b2b2b2b2b2"]

    input =  ["Apple", "bacon", "Apple", "android2.2", "2", "1watermelon"]
    expect(sort_strings input).to eq ["android2.2", "Apple", "Apple", "bacon", "1watermelon", "2"]

    input = ["OS X 10 beta: Kodiak", "OS X 10.11: El Capitan", "OS X 10.4 Tiger", "OS X 10.8 Mountain Lion", "OS X 10.6 Snow Leopard"]
    expect(sort_strings input).to eq ["OS X 10 beta: Kodiak", "OS X 10.11: El Capitan", "OS X 10.4 Tiger", "OS X 10.6 Snow Leopard", "OS X 10.8 Mountain Lion"]

    input = ["a2016-10-12ab", "a2013-02-29ac", "b2017-01-01ad", "a2016-10-10ad",  "a2016-10-10ab"]
    expect(sort_strings input).to eq ["a2016-10-10ab", "a2016-10-10ad", "a2016-10-12ab", "a2013-02-29ac", "b2017-01-01ad"]

    input = ["-1", "2", ".2", "10", "-2.4", ".2e1"] #.2 is not considered a number and is considered as a string with special character as a the prefix
    expect(sort_strings input).to eq ["-2.4", "-1", "2", "10", ".2", ".2e1"]
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
    expect(valid_date? "02-20-20").to be_falsey
  end

  it 'does not validate invalid dates' do
    expect(valid_date? "2013-02-29"). to be_falsey
    expect(valid_date? "2016-22-29"). to be_falsey
    expect(valid_date? "2016-03-32"). to be_falsey
  end
end

describe '$date_prefix_regex' do
  it 'does not match strings where is a date like format is immediately followed by a number' do
    str = '2016-10-121ab1111122'
    expect(str.match $date_prefix_regex).to be_falsey
  end

  it 'matches strings where a date like format is followed by a non-numerical characters' do
    str = '2016-10-12ab1111122'
    expect(str.match $date_prefix_regex).to be_truthy
  end
end





