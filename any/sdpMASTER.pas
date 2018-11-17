Unit sdpMASTER;
Interface
procedure CommandSlave(vSlaveName: String; vNumbers: Array of Integer); Overload;
procedure CommandSlave(vSlaveName: String; vNumber: Integer); Overload;
Implementation
procedure CommandSlave(vSlaveName: String; vNumbers: Array of Integer); Overload;
  var vNumber: Integer;
  begin
    for vNumber in vNumbers do 
      CommandSlave(vSlaveName, vNumber);
  end;
procedure CommandSlave(vSlaveName: String; vNumber: Integer); Overload;
  var vBot: TBot;
  begin
    BotList.ByName(vSlaveName, vBot);
    vBot.Control.Entry(vNumber);
  end;
end.