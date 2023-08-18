#!/usr/bin/env ruby

class Buffer
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def insert(string, position)
    @text[position - 1] = string
  end

  def delete(start, length)
    @text[start, length] = ''
  end
end

Result = Struct.new('Result', :ok, :error, keyword_init: true)

def assert(condition)
  if condition
    Result.new(ok: true)
  else
    Result.new(ok: false)
  end
end

def assert_equal(expected, actual)
  result = assert(expected == actual)

  unless result.ok
    message = <<-HEREDOC
Expected: #{expected}
Actual:   #{actual}
    HEREDOC
    result.error = message
  end
end

original_text = 'The quick brown fox jumped over the lazy dog'

buffer = Buffer.new(original_text)

buffer.insert(' speedy ', 4)
assert_equal(buffer.text, 'The speedy quick brown fox jumped over the lazy dog')

buffer.delete(36, 5)
assert_equal(buffer.text, 'The speedy quick brown fox jumped over the dog')

buffer.insert('s', 47)
assert_equal(buffer.text, 'The speedy quick brown fox jumped over the dogs')

buffer.delete(1, 4)
assert_equal(buffer.text, 'speedy quick brown fox jumped over the dogs')

buffer.insert('A', 1)
buffer.insert(' ', 2)
assert_equal(buffer.text, 'A speedy quick brown fox jumped over the dogs')

buffer.delete(42, 45)
buffer.insert('wolf', 42)
assert_equal(buffer.text, 'A speedy quick brown fox jumped over the wolf')

puts 'All assertions passed'
