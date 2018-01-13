require_relative './parser'

def files
  './files'
end

RSpec.describe Parser do
  describe '.new' do
    it 'tokenizes on instantiation' do
      parser = Parser.new("and (and(bigger 1024)(filename *.txt)) writable")
      ast = parser.expression
      expect(ast).not_to be nil
    end
  end

  describe '#expression' do
    it 'all finds all the files' do
      expr = 'all'
      count = Parser.new(expr).expression.evaluate(files).count
      expect(count).to eq 5
    end

    it 'filename finds files' do
      expr = 'filename *.txt'
      count = Parser.new(expr).expression.evaluate(files).count
      expect(count).to eq 4
    end

    it 'finds a bigger file' do
      expr = 'bigger(0)'
      ast = Parser.new(expr).expression
      result = ast.evaluate(files).count
      expect(result).to eq 1
    end

    it 'invokes not' do
      expr = 'not(filename *.txt)'
      count = Parser.new(expr).expression.evaluate(files).count
      expect(count).to eq 1
    end

    it 'finds not writable file' do
      expr = 'not writable'
      filename = Parser.new(expr).expression.evaluate(files).first
      expect(filename).to eq './files/baz.txt'
    end

    it 'bigger writable txt files' do
      expr = 'and (and(bigger 0)(filename *.txt)) writable'
      count = Parser.new(expr).expression.evaluate(files).count
      expect(count).to eq 1
    end

    it 'bigger not writable txt files' do
      expr = 'and (and(bigger 0)(filename *.txt)) (not writable)'
      count = Parser.new(expr).expression.evaluate(files).count
      expect(count).to eq 0
    end
  end
end


RSpec.describe Parser do
  describe '.new' do
    it 'tokenizes on instantiation'
  end

  describe '#expression' do
    it 'does something with ast...?'
  end
end
