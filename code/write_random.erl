-module(write_random).
-export([start/1]).

%% Author:Yin Huang
%% this is the module for writing a random float number ranging from 1.0 to 10.0
%% the file is written in append mode.
for(Max, Max, F)->
    [F(Max)];
for(I, Max, F) ->
    [F(I)|for(I+1,Max, F)].


start(N)->
    for(1,N, fun(Index)-> 
		     io:format("~p~n",[Index]),
		     String = lists:append(float_to_list(random:uniform()*5),"\n"),
		     Binary = erlang:list_to_binary(String),
		     file:write_file("data.dat",Binary,[append])
		     
		   %%  {ok, S} = file:open("data.dat", append),
		  %%  M = random:uniform(),
		  %%  io:format(S, "~p~n",[M]),
		  %%   file:close(S),
		  %%  io:format("Write ~p successfully in data.dat! ~n",[M]) 
		     end
).

