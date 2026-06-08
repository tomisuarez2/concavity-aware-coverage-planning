function index = circularIndex(x,n)
%CIRCULARINDEX Return the index of an array in a circular way.
% 
% The function allows access the elements of an array continuously,
% returning to the start when the final element is reached and
% viceversa.
%
% Input:
%   x: Absolute index of the array's element.
%   n: Number of elements in the array.
%
% Output:
%   index: Circular index of the element in the array.

    index = 1 + mod(x-1, n);
end

