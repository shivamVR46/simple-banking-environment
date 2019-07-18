%% @author Shivam Patel
%% @doc @todo Add description to customer.


-module(customer).

%% ====================================================================
%% API functions
%% ====================================================================

-import(lists,[foreach/2,get_value/2]).
-import(money,[menuForCustomers/1]).
-import(bank,[takeLoan/8]).
-import(bank,[loadBank/0]).
-import(money,[printCustomerStatement/1]).
-import(string,[join/2]).
-export([loadCustomer/0,convertToMap/1,for/7,receiveLoan/12]).




%% ====================================================================
%% Internal functions
%% ====================================================================


loadCustomer() ->
				{Result,C} = file:consult("customers.txt"),
				menuForCustomers(C),
				io:fwrite("~n"),
				bank:loadBank(),
				convertToMap(C).




convertToMap(C) -> 
				   M = maps:from_list(C),
				   MKeys = maps:keys(M),
				   io:fwrite("~p~n",[MKeys]),
				   X = map_size(M),
				   %%io:fwrite(N),
				   Term = 1,
				   {Bank,B} = file:consult("banks.txt"),
					B1 = maps:from_list(B),
				   NewMMap = M,
					for(X,Term,M,MKeys,0,B1,NewMMap).
				   		
for(X,Term,MapCustomer,MKeys,NewMValue,B1,NewMMap) when X > 0 ->
						MValue = maps:get(lists:nth(X,MKeys), MapCustomer),
						BKeys = maps:keys(B1),
						B2 = rand:uniform(length(BKeys)),
					    Money = rand:uniform(50),
						CustomerName = lists:nth(X, MKeys),
						BankName = lists:nth(B2,BKeys),
						BankValue = maps:get(BankName, B1),
						%%bank:takeLoan(CustomerName,Money,BankName,MValue,MapCustomer,NewMValue,B1),
						
						PID = spawn(bank,takeLoan,[CustomerName,Money,BankName,MValue,MapCustomer,NewMValue,B1,BankValue,X,Term,MKeys,NewMMap]),
						PID ! {self(),"Hello"},
						money:printCustomerStatement(CustomerName , Money, BankName),
						
						%%PID = spawn()
						
						if X > 1 ->
							[Term|for(X-1,Term,MapCustomer,MKeys,NewMValue,B1,NewMMap)];
					 	true ->
							io:format("")
				 		end.
				
receiveLoan(CustomerName,Bank,Money,MapCustomer,MValue,NewMValue,B1,BankValue,X,Term,MKeys,NewMMap)   ->
		Bk = maps:get(Bank,B1),
		Mk = maps:get(CustomerName, NewMMap),
	receive
			{Sender,Msg}  ->
						
						if NewMValue == MValue->
								money:printCustomerReachedStatement(CustomerName, Money);  
						true ->
								io:fwrite("")
								end,
						if (Mk < Bk)  ->
							   money:approveStatement( Bank, CustomerName, Money),
							   %%io:fwrite("~p Bank Value ~n ",[Bk]),
							   %%io:fwrite("~p CustomerValue ~p~n",[Mk,CustomerName]),
							for(X,Term,NewMMap,MKeys,NewMValue,B1,NewMMap);
						   true ->
							   money:printBankRejectionStatement(CustomerName, Bank, Money)
							  %% money:printCustomerNotReachedStatement(CustomerName, Mk)
						end,
						
						 
					Sender ! "Thanks"
		end.
