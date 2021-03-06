-module(createProc).
-export([getFrag/1,initProc/6]).
-import(network,[getRoutingTable/2,getRoutingTableMesh/2,listAppneder/2]).

getFrag(FragId) ->
 FileName =string:concat("./seg/F_",integer_to_list(FragId)),
	       io:format("Frag Id: ~p ~n", [FragId]),
 	      %io:format("Reading frag from: ~p  ~n ",[FileName]),
              {ok, Binary} = file:read_file(FileName),
	     
	      Lines1 = string:tokens(erlang:binary_to_list(Binary), "\n|,"),
		Lines = lists:map(fun(X) -> {Int, _} = string:to_float(X), Int end, Lines1).


initialise(Pidlist, Function) ->
	lists:foreach(fun(Pid) -> global:send(Pid, {initialise, Function}) end, Pidlist).	       		      

startprocessing(Pidlist, Function,Itr) ->
	case Function of
		read ->
           InitialPid = string:strip(io:get_line("Please enter the start process Id say P_#>:"), right, $\n),
	       SegId = string:strip(io:get_line("Please enter the segmentation file Id say #>:"), right, $\n),
	       io:format("MyId is ~p~n",[InitialPid]),                                                                                   
	       MyDestination =  list_to_atom(InitialPid),                                                                                          
	       io:format("MyDestination is ~p~n",[whereis(MyDestination)]),                                                                      	               
	        io:format("initialize the request to ~p for ~p ~n",[InitialPid,SegId]), 
	       TargetSegId = list_to_atom(SegId),
	       io:format("Registered: ~p~n",[registered()]),
	       global:send(MyDestination, {read, TargetSegId, MyDestination});
	       
	       write ->
	        YourTargetPid = string:strip(io:get_line("Please enter the start process Id say P_#>:"), right, $\n),
	       YourTargetSegId = string:strip(io:get_line("Please enter the segmentation file Id say #>:"), right, $\n),
	       NewValues = string:strip(io:get_line("Please enter the new value for the segmentation say 0.2,0.3,0.4>:"), right, $\n),
	       NewDestination = list_to_atom(YourTargetPid),
	       TargetSegId2 = list_to_atom(YourTargetSegId),
	       NewValues2 = list_to_atom(NewValues),
	          %NewDestination ! {write, TargetSegId2, NewValues2};
	         global:send(NewDestination,{write, TargetSegId2,NewValues2}),
		%io:format("Hey I am gonna sleep for a while"),
	         timer:sleep(10000),
		%io:format("Hey I am awake!"),
		  YesOrNo = string:strip(io:get_line("Do you wanna read the updated segmentation? Y or N>:"), right, $\n),
				       case  YesOrNo of 
					   "Y"  -> 
					       global:send( NewDestination,{read, TargetSegId2,NewDestination});
					   "y" ->
					        global:send( NewDestination,{read, TargetSegId2,NewDestination});
					   _Else ->
					       io:format("We are done!~n")
						   end;
		
	         _Else ->
	lists:foreach(fun(Pid) ->
		global:send( Pid, {timer, Function}) end, Pidlist)
		end.




initProc(-1,N,Topology,Function,Frag,Itr) -> 
%io:format("NP_id: ~p  ~n ",[]),
Pids =listAppneder(N,[]),
startprocessing(Pids, Function,Itr);


initProc(Limit,N,Topology,Function,Frag,Itr) ->  
    
     Processname = list_to_atom(string:concat( "P_" ,integer_to_list(Limit))),
     put("registeredName", Processname),
     NumNode = length(nodes())+1,
     Evaluation = (Limit rem NumNode),
	 NodeList = nodes(),
	 	io:format("Number of Nodes connected to me ~p ~n ", [NumNode]),
	 	io:format(" Nodes connected to me ~p ~n ", [NodeList]),
        FragId = (Limit rem Frag) +1,
       
	      Lines = getFrag(FragId),
	      if
	      Topology == 1  -> Route = getRoutingTable(N,Limit) ;
	      true -> Route = getRoutingTableMesh(N,Limit)
	      end,
	   %io:format("Adding route is ~p ~n ", [Route]), 
	   if
	     Evaluation == 0  -> global:register_name(Processname ,spawn_link(gossip , threadoperation , [Route,Lines,FragId, Processname,Itr,"T"]));
	     true ->  global:register_name(Processname ,spawn_link( lists:nth( Evaluation , nodes()),gossip , threadoperation , [Route,Lines,FragId, Processname,Itr,"T"]))
     end,
    global:send( Processname , { initialise, Function}),
    initProc(Limit-1,N,Topology,Function,Frag,Itr).
