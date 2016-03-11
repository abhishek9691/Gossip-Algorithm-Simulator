%%Author: Shrinivas Kane
%%Implementation of Ring and Mesh network.
%%  N Number of nodes 

-module(network).
-export([getRoutingTable/2,getRoutingTableMesh/2,listAppender/2]).


getRoutingTable(Max,N) ->
		erase("Next"),
		erase("Pre"),
   	   %io:format("Next: ~p ~n", [list_to_atom(string:concat( "P_" ,integer_to_list(N+1)))]),
 	   %io:format("Pre: ~p ~n", [list_to_atom(string:concat( "P_" ,integer_to_list(N-1)))]),
	     put("Next",list_to_atom(string:concat( "P_" ,integer_to_list(N+1)))),
	     put("Pre",list_to_atom(string:concat( "P_" ,integer_to_list(N-1)))),
	      if
	      Max == N -> erase("Next") , put("Next",list_to_atom(string:concat( "P_" ,integer_to_list(0)))) ;
	      N == 0 -> erase("Pre"), put("Pre", list_to_atom(string:concat( "P_" ,integer_to_list(N))));
	      true -> Q=1
	      end,     
	 Route = [get("Pre"),get("Next")].

listAppender(0,Route) ->
lists:append(Route, [list_to_atom(string:concat( "P_" ,integer_to_list(0)))]);

listAppender(N,Route) ->
Route1 = lists:append(Route, [list_to_atom(string:concat( "P_" ,integer_to_list(N)))]),
listAppender(N-1,Route1).

getRoutingTableMesh(Max,N) ->
X = listAppender(Max,[]),
X1 = lists:delete(list_to_atom(string:concat( "P_" ,integer_to_list(N))), X).

