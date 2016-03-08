-module(rouge_zerver).
-behavior(gen_server).
-export([init/1
        ,terminate/2
        ,handle_cast/2
        ,handle_call/3
        ,handle_info/2
        ,code_change/3
        ]).
-export([start_link/0]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, #{}, []).

init(State) ->
    lager:info("init zerver"),
    {ok, S} = ezmq:start([{type, rep}]),
    ok = ezmq:bind(S, tcp, 5555, [{reuseaddr, true},{ip, {127,0,0,1}}]),
    {ok, [SockName={_,_,_}]} = ezmq:sockname(S),
    gen_server:cast(?MODULE, loop),
    lager:info("found socket ~p:~p", [SockName, S]),
    {ok, State#{socket=>S}}.

terminate(_,_) ->
    ok.

handle_cast(loop, State=#{socket:=S}) ->
    lager:info("about to get"),
    {ok, [Bin]} = ezmq:recv(S),
    lager:info("got some bin ~p", [Bin]),
    ezmq:send(S, [Bin]),
    gen_server:cast(?MODULE, loop),
    {noreply, State};
handle_cast(_, State) ->
    lager:info("wrong one"),
    {noreply, State}.

handle_call(_, _From, State) ->
    {reply, ok, State}.

handle_info(_, State) ->
    {noreply, State}.

code_change(_, _, State) ->
    {ok, State}.
