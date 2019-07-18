%% @author Shivam Patel
%% @doc @todo Add description to bank.


-module(bank).

%% ====================================================================
%% API functions
%% ====================================================================
-import(lists,[nth/2,foreach/2,get_value/2]).
-import(money,[menuForBanks/1]).
-import(customer,[receiveLoan/5]).
-export([loadBank/0,convertToMap/1,takeLoan/12]).



%% ====================================================================
%% Internal functions
%% ====================================================================


loadBank() ->
			{Result1, C1} = file:consult("banks.txt"),
			menuForBanks(C1).
			%%convertToMap(C1).


convertToMap(C1) -> MC = maps:from_list(C1).

takeLoan(CustomerName,Money,Bank,MValue,MapCustomer,NewMValue,B1,BankValue,X,Term,MKeys,NewMMap)  -> 
				Bk = maps:get(Bank, B1),
				
					receive  
						{Sender,Msg} ->
						  	if NewMValue < Bk ->
								   if NewMValue + Money < MValue ->
										PID = spawn(customer,receiveLoan,[CustomerName,Bank,Money,MapCustomer,MValue,NewMValue + Money,maps:update(Bank, BankValue - Money, B1),BankValue - Money,X,Term,MKeys,maps:update(CustomerName, NewMValue + Money, NewMMap)]),
										PID ! {self(),"Thanks"};
							   		true ->
										money:printBankRejectionStatement(CustomerName, Bank, Money),
										money:printCustomerNotReachedStatement(CustomerName, NewMValue),
										money:printBankMoneyStatement(Bank, BankValue)
								   end;
							true ->
								money:printBankMoneyStatement(Bank, BankValue),
								money:printCustomerNotReachedStatement(CustomerName, NewMValue)
							end,
						
					Sender ! "Thanks"
					
				end.
						
							