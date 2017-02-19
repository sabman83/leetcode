require './lru.rb'
require 'rspec'

def test_dlink
end

describe DLinkedList do
  let!(:dlink) { DLinkedList.new 2 }
  before(:each) do
    dlink.add 1
    dlink.add 2
    dlink.add 3
    dlink.add 4
  end

  it 'only adds elements upto capacity' do
    expect(dlink.tail.val).to eq 3
    expect(dlink.head.val).to eq 4
  end

  it 'removes elements' do
    node = dlink.remove 3
    expect(dlink.head.val).to eq 4
    expect(dlink.tail.val).to eq 4
    expect(node.val).to eq 3
    node = dlink.remove 3
    expect(node).to eq nil
    expect(dlink.head.val).to eq 4
    expect(dlink.tail.val).to eq 4
  end

end

#["LRUCache","put","put","get","put","get","put","get","get","get"]
#[[2],[1,1],[2,2],[1],[3,3],[2],[4,4],[1],[3],[4]]
describe LRUCache do

  let!(:lru) {LRUCache.new 2}
  it 'moves get key to most recent' do
    lru.put 1,1
    lru.put 2,2
    val = lru.get 1
    expect(val).to eq 1
    expect(lru.dlink.head.val).to eq 1
  end

  it 'removes least recent when adding beyond capacity' do
    lru.put 1,1
    lru.put 2,2
    lru.get 1
    lru.put 3,3
    expect(lru.dlink.head.val).to eq 3
    expect(lru.dlink.tail.val).to eq 1
    val = lru.get 2
    expect(val).to eq -1
    lru.put 4,4
    expect(lru.dlink.head.val).to eq 4
    expect(lru.dlink.tail.val).to eq 3
  end

  #[[3],[1,1],[2,2],[3,3],[4,4],[4],[3],[2],[1],[5,5],[1],[2],[3],[4],[5]]
  it 'random' do
    lru = LRUCache.new 3
    lru.put 1,1
    lru.put 2,2
    lru.put 3,3
    lru.put 4,4
    val = lru.get 4
    expect(val).to eq 4
    val = lru.get 3
    expect(val).to eq 3
    val = lru.get 2
    expect(val).to eq 2
    val = lru.get 1
    expect(val).to eq -1
    lru.put 5,5
    val = lru.get 1
    expect(val).to eq -1
    val = lru.get 2
    expect(val).to eq 2
    val = lru.get 3
    expect(val).to eq 3
    val = lru.get 4
    expect(val).to eq -1
    val = lru.get 5
    expect(val).to eq 5
  end


end

