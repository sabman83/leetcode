# @param {String} s1
# @param {Integer} n1
# @param {String} s2
# @param {Integer} n2
# @return {Integer}

require 'pry-byebug'

def get_max_repetitions(s1, n1, s2, n2)

    return n1/n2 if s1 == s2

    s1_index = 0
    s2_index = 0
    count = 0
    loop = 0
    while(loop < n1) do

        if(s1[s1_index] == s2[s2_index])
            s2_index += 1
            binding.pry
            if( s2_index == (s2.size -1) )
                s2_index = 0
                count += 1
            end
        end

        s1_index += 1

        if(s1_index == (s1.length - 1))
            s1_index = 0
            loop += 1
        end
    end

    count / n2

end

get_max_repetitions("acb", 4, "ab", 2)
