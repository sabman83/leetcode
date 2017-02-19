require './stack.rb'

describe Stack do

  it 'adds numbers to the top' do
    stack = Stack.new
    expect(stack.top).to eq nil
    stack.add 1
    expect(stack.top).to eq 1
    stack.add 2
    expect(stack.top).to eq 2
  end

  it 'removes numbers added last' do
    stack = Stack.new
    expect(stack.remove).to eq nil
    stack.add 1
    stack.add 2
    expect(stack.remove).to eq 2
    expect(stack.size).to eq 1
    expect(stack.remove).to eq 1
    expect(stack.size).to eq 0
  end

end

