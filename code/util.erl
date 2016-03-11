%%Author: Anuja Kench
%%Implementation of simple utility functions

-module(util).
-export([sum/1,sum/2,len/1,minimum/1,maximum/1, log2/1]).


%Function to calculate Sum of elements in list
sum(List) -> 
   sum(List, 0).

sum([Head|Tail], Result) -> 
   sum(Tail, Head + Result); 

sum([], Result) ->
   Result.

%Function to calculate length of list
len([]) -> 0;
len([_|Tail]) -> 1 + len(Tail).


%Function to calculate minimum element in the list
minimum([Head|Tail]) -> minimum2(Tail,Head).
 
minimum2([], Min) -> Min;
minimum2([Head|Tail], Min) when Head < Min -> minimum2(Tail,Head);
minimum2([_|Tail], Min) -> minimum2(Tail, Min).

%Function to calculate maximum element in the list
maximum([Head|Tail]) -> maximum2(Tail,Head).
 
maximum2([], Max) -> Max;
maximum2([Head|Tail], Max) when Head > Max -> maximum2(Tail,Head);
maximum2([_|Tail], Max) -> maximum2(Tail, Max).

%Calculate logarithm to base 2 of a number
log2(X) ->
	math:log(X) / math:log(2).

