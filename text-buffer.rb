#!/usr/bin/env ruby

# Buffer is a container for text that allows insertion and deletion of arbitrary
# parts. Internally a Ruby String object and methods are used for text storage.
class Buffer
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def insert(string, position)
    head = @text[0...position - 1]

    tail = @text[(position - 1)..]

    @text = [head, string, tail].join
  end

  def delete(start, length)
    @text[start - 1, length] = ''
  end
end

# ArrayBuffer is a container for text that allows insertion and deletion of
# arbitrary parts. Internally a Ruby Array object and methods are used for text
# storage.
class ArrayBuffer
  def initialize(text)
    @text = text.grapheme_clusters
  end

  def text
    @text.join
  end

  def insert(string, position)
    @text.insert(position - 1, *string.grapheme_clusters)
  end

  def delete(start, length)
    @text.slice!(start - 1, length)
  end
end

class GapBuffer
  def initialize(text)
    @text = text.grapheme_clusters
  end

  def text
    @text.join
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

class BufferTestCase
  def run
    tests = self.methods.grep(/^test_*/)

    assertions = tests.map do |test|
      self.public_send(test)
    end

    assertions.each do |assertion|
      if assertion.ok
        puts 'Pass'
      else
        puts assertion.error
      end
    end
  end

  def test_word_insert_at_mid_index
    buffer = Buffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert(' speedy', 4)
    assert_equal(buffer.text, 'The speedy quick brown fox jumped over the lazy dog')
  end

  def test_delete_at_mid_index
    buffer = Buffer.new('The quick brown fox jumped over the lazy dog')
    buffer.delete(36, 5)
    assert_equal(buffer.text, 'The quick brown fox jumped over the dog')
  end

  def test_insert_character_at_end
    buffer = Buffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert('s', 45)
    assert_equal(buffer.text, 'The quick brown fox jumped over the lazy dogs')
  end

  def test_delete_at_start
    buffer = Buffer.new('The quick brown fox jumped over the lazy dog')
    buffer.delete(1, 4)
    assert_equal(buffer.text, 'quick brown fox jumped over the lazy dog')
  end

  def test_insert_character_at_start
    buffer = Buffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert('A', 1)
    assert_equal(buffer.text, 'AThe quick brown fox jumped over the lazy dog')
  end
end

class ArrayBufferTestCase
  def run
    tests = self.methods.grep(/^test_*/)

    assertions = tests.map do |test|
      self.public_send(test)
    end

    assertions.each do |assertion|
      if assertion.ok
        puts 'Pass'
      else
        puts assertion.error
      end
    end
  end

  def test_word_insert_at_mid_index
    buffer = ArrayBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert(' speedy', 4)
    assert_equal(buffer.text, 'The speedy quick brown fox jumped over the lazy dog')
  end

  def test_delete_at_mid_index
    buffer = ArrayBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.delete(36, 5)
    assert_equal(buffer.text, 'The quick brown fox jumped over the dog')
  end

  def test_insert_character_at_end
    buffer = ArrayBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert('s', 45)
    assert_equal(buffer.text, 'The quick brown fox jumped over the lazy dogs')
  end

  def test_delete_at_start
    buffer = ArrayBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.delete(1, 4)
    assert_equal(buffer.text, 'quick brown fox jumped over the lazy dog')
  end

  def test_insert_character_at_start
    buffer = ArrayBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert('A', 1)
    assert_equal(buffer.text, 'AThe quick brown fox jumped over the lazy dog')
  end
end

class GapBufferTestCase
  def run
    tests = self.methods.grep(/^test_*/)

    assertions = tests.map do |test|
      self.public_send(test)
    end

    assertions.each do |assertion|
      if assertion.ok
        puts 'Pass'
      else
        puts assertion.error
      end
    end
  end

  def test_word_insert_at_mid_index
    buffer = GapBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert(' speedy', 4)
    assert_equal(buffer.text, 'The speedy quick brown fox jumped over the lazy dog')
  end

  def test_delete_at_mid_index
    buffer = GapBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.delete(36, 5)
    assert_equal(buffer.text, 'The quick brown fox jumped over the dog')
  end

  def test_insert_character_at_end
    buffer = GapBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert('s', 45)
    assert_equal(buffer.text, 'The quick brown fox jumped over the lazy dogs')
  end

  def test_delete_at_start
    buffer = GapBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.delete(1, 4)
    assert_equal(buffer.text, 'quick brown fox jumped over the lazy dog')
  end

  def test_insert_character_at_start
    buffer = GapBuffer.new('The quick brown fox jumped over the lazy dog')
    buffer.insert('A', 1)
    assert_equal(buffer.text, 'AThe quick brown fox jumped over the lazy dog')
  end
end

BufferTestCase.new.run
ArrayBufferTestCase.new.run
GapBufferTestCase.new.run
