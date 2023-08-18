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

def assert_equal(expected, actual)
  result = assert(expected == actual)

  unless result.ok
    message = <<-HEREDOC
Expected: #{expected}
Actual:   #{actual}
    HEREDOC
    result.error = message
  end

  result
end

original_text = 'The quick brown fox jumped over the lazy dog'

buffer = Buffer.new(original_text)

buffer.insert(' speedy ', 4)
assertion = assert_equal(buffer.text, 'The speedy quick brown fox jumped over the lazy dog')

unless assertion.ok
  puts assertion.error
end

assertion = nil

buffer.delete(36, 5)
assertion = assert_equal(buffer.text, 'The speedy quick brown fox jumped over the dog')

unless assertion.ok
  puts assertion.error
end

assertion = nil

buffer.insert('s', 47)
assertion = assert_equal(buffer.text, 'The speedy quick brown fox jumped over the dogs')

unless assertion.ok
  puts assertion.error
end

assertion = nil

buffer.delete(1, 4)
assertion = assert_equal(buffer.text, 'speedy quick brown fox jumped over the dogs')

unless assertion.ok
  puts assertion.error
end

assertion = nil

buffer.insert('A', 1)
buffer.insert(' ', 2)
assertion = assert_equal(buffer.text, 'A speedy quick brown fox jumped over the dogs')

unless assertion.ok
  puts assertion.error
end

assertion = nil

buffer.delete(42, 45)
buffer.insert('wolf', 42)
assertion = assert_equal(buffer.text, 'A speedy quick brown fox jumped over the wolf')

array_buffer = ArrayBuffer.new(original_text)

array_buffer.insert(' speedy ', 4)
assertion = assert_equal(array_buffer.text, 'The speedy quick brown fox jumped over the lazy dog')

unless assertion.ok
  puts assertion.error
end

assertion = nil

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

puts 'All assertions complete'
