require './bst.rb'
require 'rspec'

describe 'build_tree' do
  it 'builds the correct tree given an array of elements' do

    arr = [5,3,6,2,4,nil,7]
    #Expected Tree
    #           5
    #         /  \
    #         3    6
    #        / \  / \
    #       2  4     7

    root = build_tree(arr)

    expect(root.val).to eq 5

    expect(root.left.val).to eq 3
    expect(root.left.left.val).to eq 2
    expect(root.left.right.val).to eq 4

    expect(root.right.val).to eq 6
    expect(root.right.left).to eq nil
    expect(root.right.right.val).to eq 7
  end
end



