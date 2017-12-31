require './expression'

RSpec.describe All do
  describe '#evaluate' do
    it '' do
      expect(All.new.evaluate('./files').count).to eq 1
    end
  end
end

RSpec.describe Filename do
  describe '#evaluate' do
    it '' do
      count = Filename.new('foo.txt').evaluate('./files').count
      expect(count).to eq 1
    end

    it 'handles regex *.txt'
  end
end

RSpec.describe Bigger do
  describe '#evaluate' do
    it 'finds non-empty files'
  end
end

RSpec.describe Writable do
  describe '#evaluate' do
    it 'finds writable files'
  end
end

RSpec.describe Not do
  describe '#evaluate' do
    it 'finds the non-writable files'
  end
end

RSpec.describe Or do
  describe '#evaluate' do
    it 'finds txt and writable files'
  end
end

RSpec.describe And do
  describe '#evaluate' do
    it 'finds big non-writable files'
  end
end
