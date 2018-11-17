unit sdpTARGETs;
interface
function targetByTitle(patrn: String; maxDist: Integer = 500): Boolean;
function countMobTargetors(target: TL2Live; count_party, count_clan: Boolean = False): Integer; 
function countMobInZone(isDead: Boolean = False): Integer;

function findMostSurounded(vRange: Integer = 800; vArea: Integer = 300; atLeast: Integer = 0): TL2NPC;

procedure waitTargetDead();

implementation
Uses sdpSTRINGS, sdpREGEX;
function targetByTitle(patrn: String; maxDist: Integer = 500): Boolean;
  var
    aNPC: TL2NPC;
       i: Integer;
  begin
    Result := False;
    for i := 0 to NpcList.Count - 1 do
    begin
      aNPC := NpcList.Items(i);
      if   str_detect(aNPC.Title, patrn)
       and not aNPC.Dead
       and (User.DistTo(aNPC) < maxDist)
       and (aNPC <> User.Target)
      then
      begin
        Engine.SetTarget(aNPC);
        Print(aNPC.Name + '[' + aNPC.Title + ']');
        Result := True;
        Break;
      end;
    end;
  end;
function countMobTargetors(target: TL2Live; count_party, count_clan: Boolean = False): Integer;
  var
    allMobList: TNpcList; i: Integer;
  begin
    Result := 0;
    allMobList := Engine.GetNPCList;
    for i := 0 to allMobList.Count - 1 do begin
      if (not allMobList.Items(i).IsMember or count_party) and ((allMobList.Items(i).ClanID <> Target.ClanID) or count_clan) then 
      if (allMobList.Items(i).Target = target) then Result := Result + 1;
    end;
  end;
function countMobInZone(isDead: Boolean = False): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      if NpcList.Items(i).InZone and NpcList.Items(i).Valid then 
      begin
        if (isDead and NpcList.Items(i).Dead and NpcList.Items(i).Sweepable) 
          or ((not isDead) and (not NpcList.Items(i).Dead))
        then 
          Result := Result + 1;
      end;
    end;
  end;

function findMostSurounded(vRange: Integer = 800; vArea: Integer = 300; atLeast: Integer = 0): TL2NPC;
  var
  //Result: TL2NPC;
    best_sum: Integer;
    i,j: Integer;
    NPCList1: TL2List;
    aNPC: TL2Npc;
    this_sum: Integer;
  begin
    if (User.DistTo(NPCList1.Items(0) as TL2NPC) < vRange) then
    begin
      NPCList1 := NPCList;
      for i:=0 to NPCList1.Count - 1 do
      begin
        aNPC := NPCList1.Items(i) as TL2NPC;
        this_sum := 0;
        if (User.DistTo(aNPC) > vRange) then break;
        if not aNPC.Dead then
        begin
          for j:=0 to NPCList.Count - 1 do
          begin
            if(User.DistTo(NPCList.Items(j)) < vRange + vArea) then 
              if (aNPC.DistTo(NPCList.Items(j)) < vArea) then
              begin
                this_sum := this_sum + 1;
              end
            else break;
          end;
          if (this_sum > best_sum)
            or ((this_sum = best_sum) and (User.DistTo(aNPC)< User.DistTo(Result)))
          then
          begin
            if (best_sum >= atLeast) then 
            begin
              best_sum := this_sum;
              Result := aNPC;
            end;
          end;
        end;
      end;
    end else
    Result := Nil;
  end;
procedure waitTargetDead();
  begin
    while (not User.Target.Dead)
      and (User.Target.Name <> User.Name)
      and (User.Target <> Nil)
    do 
    delay(50);
  end;
end.