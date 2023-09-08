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
  def initialize
    original_text = 'The quick brown fox jumped over the lazy dog'
    @buffer = Buffer.new(original_text)
    @assertions = []
  end

  def run
    test1
    test2
    test3
    test4
    test5
    test6

    @assertions.each do |assertion|
      if assertion.ok
        puts 'Pass'
      else
        puts assertion.error
      end
    end
  end

  def test1
    @buffer.insert(' speedy', 4)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the lazy dog')
  end

  def test2
    @buffer.delete(43, 5)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the dog')
  end

  def test3
    @buffer.insert('s', 47)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the dogs')
  end

  def test4
    @buffer.delete(1, 4)
    @assertions << assert_equal(@buffer.text, 'speedy quick brown fox jumped over the dogs')
  end

  def test5
    @buffer.insert('A', 1)
    @buffer.insert(' ', 2)
    @assertions << assert_equal(@buffer.text, 'A speedy quick brown fox jumped over the dogs')
  end

  def test6
    @buffer.delete(42, 45)
    @buffer.insert('wolf', 42)
    @assertions << assert_equal(@buffer.text, 'A speedy quick brown fox jumped over the wolf')
  end
end

class ArrayBufferTestCase
  def initialize
    original_text = 'The quick brown fox jumped over the lazy dog'
    @buffer = ArrayBuffer.new(original_text)
    @assertions = []
  end

  def run
    test1
    test2
    test3
    test4
    test5
    test6

    @assertions.each do |assertion|
      if assertion.ok
        puts 'Pass'
      else
        puts assertion.error
      end
    end
  end

  def test1
    @buffer.insert(' speedy', 4)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the lazy dog')
  end

  def test2
    @buffer.delete(43, 5)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the dog')
  end

  def test3
    @buffer.insert('s', 47)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the dogs')
  end

  def test4
    @buffer.delete(1, 4)
    @assertions << assert_equal(@buffer.text, 'speedy quick brown fox jumped over the dogs')
  end

  def test5
    @buffer.insert('A', 1)
    @buffer.insert(' ', 2)
    @assertions << assert_equal(@buffer.text, 'A speedy quick brown fox jumped over the dogs')
  end

  def test6
    @buffer.delete(42, 45)
    @buffer.insert('wolf', 42)
    @assertions << assert_equal(@buffer.text, 'A speedy quick brown fox jumped over the wolf')
  end
end

class GapBufferTestCase
  def initialize
    original_text = 'The quick brown fox jumped over the lazy dog'
    @buffer = GapBuffer.new(original_text)
    @assertions = []
  end

  def run
    test1
    test2
    test3
    test4
    test5
    test6

    @assertions.each do |assertion|
      if assertion.ok
        puts 'Pass'
      else
        puts assertion.error
      end
    end
  end

  def test1
    @buffer.insert(' speedy', 4)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the lazy dog')
  end

  def test2
    @buffer.delete(43, 5)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the dog')
  end

  def test3
    @buffer.insert('s', 47)
    @assertions << assert_equal(@buffer.text, 'The speedy quick brown fox jumped over the dogs')
  end

  def test4
    @buffer.delete(1, 4)
    @assertions << assert_equal(@buffer.text, 'speedy quick brown fox jumped over the dogs')
  end

  def test5
    @buffer.insert('A', 1)
    @buffer.insert(' ', 2)
    @assertions << assert_equal(@buffer.text, 'A speedy quick brown fox jumped over the dogs')
  end

  def test6
    @buffer.delete(42, 45)
    @buffer.insert('wolf', 42)
    @assertions << assert_equal(@buffer.text, 'A speedy quick brown fox jumped over the wolf')
  end
end

BufferTestCase.new.run
ArrayBufferTestCase.new.run
GapBufferTestCase.new.run
