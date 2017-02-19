
files = []
dir = []
root = "/Users/skolman/Projects/leetcode"
arr = [];
arr.push root
while arr.size > 0 do
  file_path = arr.pop
  Dir.entries(file_path).each do |item|
    next if(item == "." || item == "..")
    #puts "processing " + item
    if File.directory? File.join(file_path,item)
      puts item + " is a directory"
      arr.push File.join(file_path, item)
    else
      files.push item
    end
  end
end
#puts "Files : " ,files
