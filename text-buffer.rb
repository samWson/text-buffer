#!/usr/bin/env ruby

# Buffer is a container for text that allows insertion and deletion of arbitrary
# parts. Internally a Ruby String object and methods are used for text storage.
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

# ArrayBuffer is a container for text that allows insertion and deletion of
# arbitrary parts. Internally a Ruby Array object and methods are used for text
# storage.
class ArrayBuffer
  attr_reader :text

  def initialize(text)
    @text = []
  end

  def insert(string, position)

  end

  def delete(start, length)

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

def assert_equal(actual, expected)
  result = assert(actual == expected)

  unless result.ok
    message = <<-HEREDOC
Expected: #{expected}
Actual:   #{actual}
    HEREDOC
    result.error = message
  end

  result
end

assertions = []

original_text = 'The quick brown fox jumped over the lazy dog'

buffer = Buffer.new(original_text)

buffer.insert(' speedy ', 4)
assertions << assert_equal(buffer.text, 'The speedy quick brown fox jumped over the lazy dog')

buffer.delete(43, 5)
assertions << assert_equal(buffer.text, 'The speedy quick brown fox jumped over the dog')

buffer.insert('s', 47)
assertions << assert_equal(buffer.text, 'The speedy quick brown fox jumped over the dogs')

buffer.delete(1, 4)
assertions << assert_equal(buffer.text, 'speedy quick brown fox jumped over the dogs')

# TODO: to make this pass it needs to shift the rest of the buffer to the next index
# currently it replaces the character at the index.
buffer.insert('A', 1)
buffer.insert(' ', 2)
assertions << assert_equal(buffer.text, 'A speedy quick brown fox jumped over the dogs')

# buffer.delete(42, 45)
# buffer.insert('wolf', 42)
# assertions << assert_equal(buffer.text, 'A speedy quick brown fox jumped over the wolf')

# array_buffer = ArrayBuffer.new(original_text)

# array_buffer.insert(' speedy ', 4)
# assertion = assert_equal(array_buffer.text, 'The speedy quick brown fox jumped over the lazy dog')

# array_buffer.delete(36, 5)
# assert_equal(array_buffer.text, 'The speedy quick brown fox jumped over the dog')

# array_buffer.insert('s', 47)
# assert_equal(array_buffer.text, 'The speedy quick brown fox jumped over the dogs')

# array_buffer.delete(1, 4)
# assert_equal(array_buffer.text, 'speedy quick brown fox jumped over the dogs')

# array_buffer.insert('A', 1)
# array_buffer.insert(' ', 2)
# assert_equal(array_buffer.text, 'A speedy quick brown fox jumped over the dogs')

# array_buffer.delete(42, 45)
# array_buffer.insert('wolf', 42)
# assert_equal(array_buffer.text, 'A speedy quick brown fox jumped over the wolf')

assertions.each do |assertion|
  unless assertion.ok
    puts assertion.error
  end
end

puts 'All assertions complete'
