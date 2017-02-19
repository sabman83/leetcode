require './queue.rb'

describe Queue do
  it 'enqueues elements to the end' do
    q = Queue.new
    q.enqueue 1
    q.enqueue 2
    q.enqueue 3
    expect(q.top).to eq 1
    q.dequeue
    expect(q.top).to eq 2
  end
end

