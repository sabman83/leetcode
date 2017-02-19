#An element in a sorted array can be found in O(log n) time via binary search.
#But suppose we rotate an ascending order sorted array at some pivot unknown to you beforehand.
#So for instance, 1 2 3 4 5 might become 3 4 5 1 2.
#Devise a way to find an element in the rotated array in O(log n) time.
#


require 'rspec'


def find_element arr, elem

  mid = arr.size-1 / 2

  return mid if arr[mid] == elem

  return 0 if arr.first == elem
  return arr.size - 1 if arr.last == elem

  if elem > arr[mid]
    if elem < arr.last
      h = arr.length - 1
      l = mid
    else
      h = mid
      l = 0
    end
  else
    if elem > arr.first
      h = mid
      l = 0
    else
      l = mid
      h = arr.length - 1
    end
  end

  #binary search


end


describe '#find_element' do
  it 'finds index of element' do
    arr = [5, 6, 7, 8, 9, 10, 1, 2, 3];
    result = find_element arr, 3
    expect(result).to eq 8

    arr = [5, 6, 7, 8, 9, 10, 1, 2, 3];
    result = find_element arr, 30
    expect(result).to eq nil

    arr = [30, 40, 50, 10, 20];
    result = find_element arr, 10
    expect(result).to eq 3

    arr = [5,6,7,8,9,1,4]
    result = find_element arr, 1
    expect(result).to eq 5
  end
end

