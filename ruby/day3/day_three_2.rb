message = File.read("input.txt").chomp

require "strscan"

class Lexer
  PATTERNS = {
    /mul/ => :MUL,
    /do\(\)/ => :DO,
    /don't\(\)/ => :DONT,
    /[0-9]+/ => :NUMBER,
    /,/ => :COMMA,
    /\(/ => :LPAREN,
    /\)/ => :RPAREN,
    /./m => :UNKNOWN,
  }
  def self.tokenize(str)
    new.tokenize(str)
  end

  def tokenize(str)
    tokens = []
    scanner = StringScanner.new(str)
    until scanner.eos?
      PATTERNS.each do |pattern, type|
        if scanned_token = scanner.scan(pattern)
          tokens << [type, scanned_token]
          break
        end
      end
    end
    tokens
  end
end

class Parser
  def self.parse(tokens)
    new.parse(tokens)
  end

  def parse(tokens)
    instructions = []
    tokens.each_with_index do |token, index|
      token_type, token_value = token
      case token_type
      when :MUL
        if check_valid_mul(tokens[index..index + 5])
          instructions << tokens[index..index + 5]
        end
      when :DO
        instructions << [tokens[index]]
      when :DONT
        instructions << [tokens[index]]
      end
    end
    instructions
  end

  def check_valid_mul(tokens)
    tokens.map(&:first) == [:MUL, :LPAREN, :NUMBER, :COMMA, :NUMBER, :RPAREN]
  end
end

class Runtime
  def self.run(instruction)
    new.run(instruction)
  end

  def run(instruction)
    operation = instruction[0][0]

    case operation
    when :MUL
      _operation, _lp, a, _comma, b, _rp = instruction
      a = a[1].to_i
      b = b[1].to_i
      a * b
    end
  end
end

class StatefulRuntime
  attr_reader :mul_enabled
  def self.run(instructions)
    new.run(instructions)
  end

  def initialize()
    @mul_enabled = true
  end

  def do_multiply
    @mul_enabled = true
  end

  def dont_multiply
    @mul_enabled = false
  end

  def run(instructions)
    products = []
    instructions.each do |instruction|
      operation = instruction[0][0]
      case operation
      when :MUL
        if mul_enabled
          products << Runtime.run(instruction)
        end
      when :DO
        do_multiply
      when :DONT
        dont_multiply
      end
    end
    products.sum
  end
end

tokens = Lexer.tokenize(message)

instructions = Parser.parse(tokens)

product = StatefulRuntime.run(instructions)
puts product
