require "byebug"
#General Problems
def no_dupes?(array)
    array.select {|el| array.count(el) == 1}
end

def no_consecutive_repeats?(array)
    (0...array.length).each do |i| return false if array[i] == array[i+1] end
    true
end

def char_indices(string)
    indices = Hash.new {Array.new(0)}
    string.split("").each_with_index do |char,i|
        if !indices.key?(char)
            indices[char] = [i] 
        else
            indices[char] << i
        end
    end
    indices
end

def longest_streak(string)
    count = 1
    max = 1
    char = string[0]
    (0...string.length).each do |i|
        if string[i] == string[i+1]
            count += 1
        else
            if count >= max
                max = count
                char = string[i]
                count = 1
            end
        end
    end
    char*max
end

def prime?(num)
    return false if num < 2
    (2...num).each do |i| return false if num % i == 0 end
    true
end

def bi_prime?(num)
    factors = Hash.new(0)
    (1..num).each do |i|
        factors[i] = num / i if num % i == 0
    end
    factors.any? {|key,value| prime?(key) && prime?(value)}
end

def vigenere_cipher(message,keys)
    alphabet = ('a'..'z').to_a
    result = ""
    nums = keys
    message.split("").each do |char|
        place = alphabet.index(char)
        result += alphabet[(place+nums[0]) % 26]
        nums = nums.rotate()
    end
    result
end

def vowel_rotate(str)
    vowels = ['a','e','i','o','u']
    found = []
    str.chars().each_with_index do |char,i| found << [char,i] if vowels.include?(char) end
    replace = Hash.new(0)
    replace[found[0][1]] = found[-1][0]
    (1...found.length).each do |i| replace[found[i][1]] = found[i-1][0] end
    new_s = ""
    (0...str.length).each do |i|
        if replace.key?(i)
            new_s += replace[i]
        else
            new_s += str[i]
        end
    end
    new_s
end

#Proc Problems

class String
    def select(&prc)
        return "" if prc == nil
        new_s = ""
        self.split("").each do |char| new_s += char if prc.call(char) end
        new_s
    end

    def map!(&prc)
        (0...self.length).each do |i| self[i] = prc.call(self[i],i) end
    end
end

#Recursion Problems

def multiply(a,b)
    return 0 if a == 0 || b == 0
    return a if b == 1
    if (a > 0 && b > 0) || (a < 0 && b < 0)
        positive = true
    else
        positive = false
    end
    result = a.abs() + multiply(a.abs(),b.abs()-1)
    return result if positive
    -result
end

def lucas_sequence(length)
    return [] if length == 0
    return [2] if length == 1
    return [2,1] if length == 2
    sequence = lucas_sequence(length-1)
    next_num = sequence[-1] + sequence[-2]
    sequence << next_num
    sequence
end

def prime_factorization(num)
    return [num] if prime?(num)
    factors = []
    (2..num).each do |i|
        if num%i == 0
            factors << [i] + prime_factorization(num/i) 
            break
        end
    end
    factors.flatten
end


# General Problems
puts "General Problems"

puts "no_dupes? Examples"
# Examples
p no_dupes?([1, 1, 2, 1, 3, 2, 4])         # => [3, 4]
p no_dupes?(['x', 'x', 'y', 'z', 'z'])     # => ['y']
p no_dupes?([true, true, true])            # => []

puts "no_consecutive_repeats? Examples"
# Examples
p no_consecutive_repeats?(['cat', 'dog', 'mouse', 'dog'])     # => true
p no_consecutive_repeats?(['cat', 'dog', 'dog', 'mouse'])     # => false
p no_consecutive_repeats?([10, 42, 3, 7, 10, 3])              # => true
p no_consecutive_repeats?([10, 42, 3, 3, 10, 3])              # => false
p no_consecutive_repeats?(['x'])                              # => true

puts "char_indices Examples"
# Examples
p char_indices('mississippi')   # => {"m"=>[0], "i"=>[1, 4, 7, 10], "s"=>[2, 3, 5, 6], "p"=>[8, 9]}
p char_indices('classroom')     # => {"c"=>[0], "l"=>[1], "a"=>[2], "s"=>[3, 4], "r"=>[5], "o"=>[6, 7], "m"=>[8]}

puts "longest_streak Examples"
# Examples
p longest_streak('a')           # => 'a'
p longest_streak('accccbbb')    # => 'cccc'
p longest_streak('aaaxyyyyyzz') # => 'yyyyy
p longest_streak('aaabbb')      # => 'bbb'
p longest_streak('abc')         # => 'c'

puts "bi_prime? Examples"
# Examples
p bi_prime?(14)   # => true
p bi_prime?(22)   # => true
p bi_prime?(25)   # => true
p bi_prime?(94)   # => true
p bi_prime?(24)   # => false
p bi_prime?(64)   # => false


# vigenere_cipher("bananasinpajamas",[1,2,3])
# Message:  b a n a n a s i n p a j a m a s
# Keys:     1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1
# Result:   c c q b p d t k q q c m b o d t

puts "vigenere_cipher Examples"
# Examples
p vigenere_cipher("toerrishuman", [1])        # => "upfssjtivnbo"
p vigenere_cipher("toerrishuman", [1, 2])     # => "uqftsktjvobp"
p vigenere_cipher("toerrishuman", [1, 2, 3])  # => "uqhstltjxncq"
p vigenere_cipher("zebra", [3, 0])            # => "ceerd"
p vigenere_cipher("yawn", [5, 1])             # => "dbbo"

puts "vowel_rotate Examples"
# Examples
p vowel_rotate('computer')      # => "cempotur"
p vowel_rotate('oranges')       # => "erongas"
p vowel_rotate('headphones')    # => "heedphanos"
p vowel_rotate('bootcamp')      # => "baotcomp"
p vowel_rotate('awesome')       # => "ewasemo"


#Proc Problems
puts "Proc Problems"

puts "String#select Examples"
# Examples
p "app academy".select { |ch| !"aeiou".include?(ch) }   # => "pp cdmy"
p "HELLOworld".select { |ch| ch == ch.upcase }          # => "HELLO"
p "HELLOworld".select          # => ""

puts "map! Examples"
# Examples
word_1 = "Lovelace"
word_1.map! do |ch| 
    if ch == 'e'
        '3'
    elsif ch == 'a'
        '4'
    else
        ch
    end
end
p word_1        # => "Lov3l4c3"

word_2 = "Dijkstra"
word_2.map! do |ch, i|
    if i.even?
        ch.upcase
    else
        ch.downcase
    end
end
p word_2        # => "DiJkStRa"


#Recursion Problems
puts "Recursion Problems"

puts "multiply Examples"
# Examples
p multiply(3, 5)        # => 15
p multiply(5, 3)        # => 15
p multiply(2, 4)        # => 8
p multiply(0, 10)       # => 0
p multiply(-3, -6)      # => 18
p multiply(3, -6)       # => -18
p multiply(-3, 6)       # => -18

puts "lucas_sequence Examples"
# Examples
p lucas_sequence(0)   # => []
p lucas_sequence(1)   # => [2]    
p lucas_sequence(2)   # => [2, 1]
p lucas_sequence(3)   # => [2, 1, 3]
p lucas_sequence(6)   # => [2, 1, 3, 4, 7, 11]
p lucas_sequence(8)   # => [2, 1, 3, 4, 7, 11, 18, 29]

puts "prime_factorization Examples"
# Examples
p prime_factorization(12)     # => [2, 2, 3]
p prime_factorization(24)     # => [2, 2, 2, 3]
p prime_factorization(25)     # => [5, 5]
p prime_factorization(60)     # => [2, 2, 3, 5]
p prime_factorization(7)      # => [7]
p prime_factorization(11)     # => [11]
p prime_factorization(2017)   # => [2017]