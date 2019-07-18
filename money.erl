%% @author Shivam Patel
%% @doc @todo Add description to msater.


-module(money).

%% ====================================================================
%% API functions
%% ====================================================================

-import(lists,[nth/2,foreach/2,get_value/2]).
-import(customer,[loadCustomer/0]).
-import(bank,[loadBank/0]).
-export([start/0,menuForCustomers/1,menuForBanks/1,printCustomerStatement/3,printBankMoneyStatement/2,printBankRejectionStatement/3,printCustomerReachedStatement/2,printCustomerNotReachedStatement/2,approveStatement/3]).

			
		
%% ====================================================================
%% Internal functions
%% ====================================================================

start() ->
			 loadCustomer().


menuForCustomers(C) ->  io:fwrite("** Customers and loan objectives **"),
						io:fwrite("~n"),
						lists:foreach(fun({Key, Val}) -> io:format("~p: ~p~n",[Key, Val]) end, C),
						io:fwrite("~n").


menuForBanks(C1) -> 	io:fwrite("** Bank and financial resources **"),
						io:fwrite("~n"),
						lists:foreach(fun({Key,Val})-> io:format("~p: ~p~n",[Key,Val]) end, C1).

printCustomerStatement(M1,M2,M3) -> 
										 	
										  io:fwrite("~p requests a loan of ~p dollar(s) from ~p~n",[M1,M2,M3]).
										  
printBankMoneyStatement(Bank,BankValue) -> 
							
										 io:fwrite("~p has only ~p dollar(s) remaining ~n",[Bank,BankValue]).
										 
printBankRejectionStatement(Customer,Bank,Money) ->
			
										io:fwrite("~p rejects the loan request of ~p dollar(s) from ~p~n",[Bank,Money,Customer]).
										
printCustomerReachedStatement(MKeys,Money) ->
						
												io:fwrite("~p reached the objective of ~p~n",[MKeys,Money]).
		
						
printCustomerNotReachedStatement(MKeys,Money) ->
												io:fwrite("~p can only take ~p dollars(s). Boo Hoo ! ~n",[MKeys, Money] ).


approveStatement(Bank,MKeys,Money) ->
													io:fwrite("~p approved the loan of ~p dollars(s) from ~p~n",[Bank,Money,MKeys]).
											