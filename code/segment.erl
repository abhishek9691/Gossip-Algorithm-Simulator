-module(segment).
-export ([segfile/2,for/3]).
%%  author: Yin Huang
%%  Input: 1. filename to be segmented for example: ""./data/data.dat"
%%         2. Size of the chunk (all equal) so the number of fragments = size of data / size of the chunk.
%%  Output: same size chunks of the original file written to ./seg/F_index
%%  Note:   output directory is hard coded as under ./seg so you need to mkdir seg under current directory 



for(Max, Max, F) ->
    [F(Max)];
for(I, Max,F) ->
    [F(I)|for(I+1,Max, F)].


 segfile(FileName,N) ->
    filelib:ensure_dir("seg/"),
    {ok,ChildFiles} = file:list_dir_all("seg"),
    lists:foreach(fun(Files)->file:delete(string:concat("seg/",Files)) end, ChildFiles),
    file:del_dir("seg"),
    file:make_dir("seg"),
    {ok, Binary} = file:read_file(FileName),
    Lines = string:tokens(erlang:binary_to_list(Binary), "\n"),
    L =length(Lines),
	if L =< N -> Step = (N div length(Lines));
	true -> Step = (length(Lines) div N)
	end,
    MyLists = [ lists:sublist(Lines, X, Step) || X <- lists:seq(1,length(Lines),Step) ],
     for(1,length(MyLists), fun(Index) ->
				    filewrite(string:concat("./seg/F_", integer_to_list(Index)),lists:nth(Index,MyLists)),
	                           io:format("~p has been written to ~p ~n", [FileName,string:concat("./seg/F_", integer_to_list(Index)) ])
					end
	).

  
filewrite(File, L) ->
   case file:open(File, [write]) of
      {ok, Device} ->
         lists:foreach(fun(Line) -> writeline(Device, Line) end, L),
         file:close(Device)
   end.

writeline(Device, Line) -> writeline(Device, Line, os:type()).


%%Write File to device
writeline(Device, Line, {win32,_}) -> io:fwrite(Device, "~s\r\n", [Line]);
writeline(Device, Line, _) -> io:fwrite(Device, "~s\n", [Line]).
