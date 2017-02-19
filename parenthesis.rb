require 'pry-byebug'
# @param {String} s
# @return {Integer}

def longest_valid_parentheses(s)
    stack  = []
    # push i if ( else
    for i in 0...s.length do
        if s[i] == '('
            stack.push i
        else

            if stack.size > 0 && s[stack.last] == '('
                stack.pop
            else
                stack.push i
            end
        end
    end

    return s.length if (stack.size == 0)

    # you have unmatched positions in stack, get longest
    binding.pry
    # for each index, separate two parts, from last index to curr and curr to next
    prev = s.length
    longest  = 0
    while stack.size > 0
      curr = stack.pop
      longest = prev - curr if (prev - curr - 1) > longest
      prev = curr
    end

    longest = prev > longest ? prev : longest

    longest

end

longest_valid_parentheses("(()")
