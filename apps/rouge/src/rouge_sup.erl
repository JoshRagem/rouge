%%%-------------------------------------------------------------------
%% @doc rouge top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module('rouge_sup').

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Child = #{id => z,
              start => {rouge_zerver, start_link, []}
             },
    {ok, {#{strategy => one_for_all,
            intensity => 0,
            period =>1}, [Child]}}.

%%====================================================================
%% Internal functions
%%====================================================================
