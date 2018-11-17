unit sdpCounter;
interface
procedure waitFinishCasting(caster: TL2Live);

procedure useBuffs(arr: Array of String); Overload;
procedure useSkills(arr: Array of String; vMaxWaitReuse: Integer = 0); Overload;
procedure useSkills(vControl: TL2Control; arr: Array of String; vMaxWaitReuse: Integer = 0); Overload;

procedure setToggle(arr: Array of String; vState: Boolean); Overload;
function countMobTargetors(): Integer; Overload;
function countMobTargetors(vParam1: TL2Live): Integer; Overload;
function countMobArround(vRange: Integer = 300): Integer; Overload;
function countMobsInZone(z: Integer = 500): Integer; Overload;
function countSpoiledMobs(vRange: Integer = 300): Integer; Overload;
function skillReuse(vName: String): Integer; Overload;

function buffCount(arr: Array of String; time: Integer = 60000): Integer; Overload;
function buffCount(nick: String; arr: Array of String; time: Integer = 60000): Integer; Overload;
function buffCount(nick: String; time: Integer = 60000): Integer; Overload;
function buffCount(time: Integer = 60000): Integer; Overload;
function buffCount(vControl: TL2Control; arr: Array of String; time: Integer = 60000): Integer; Overload; 

function buffTime(vID: Integer): Integer; Overload;
function buffTime(vName: String): Integer; Overload;

function countItems(vID: Integer): Integer; Overload;
function countItems(vName: String): Integer; Overload;
function itemCountIs(vID: Integer; count: Integer): Boolean; Overload;
function itemCountIs(vName: String; count: Integer): Boolean; Overload;

procedure faceControl(face: Integer = -1; combat: Integer = -1; healing: Integer = -1; buffs: Integer = -1; events: Integer = -1);
implementation
Uses sdpStrings;
procedure waitFinishCasting(caster: TL2Live);
  begin
    Delay(caster.Cast.EndTime);
  end;
procedure useBuffs(arr: Array of String); Overload;
  begin
    Engine.SetTarget(User);
    UseSkills(arr);
  end;
procedure useSkills(arr: Array of String; vMaxWaitReuse: Integer = 0); Overload;
  begin
    useSkills(Engine, arr, vMaxWaitReuse);
  end;
procedure useSkills(vControl: TL2Control; arr: Array of String; vMaxWaitReuse: Integer = 0); Overload;
  var part: String; i: Integer;
  begin
    if Length(arr) > 0 then
      for i := 0 to Length(arr) - 1 do
      begin
        part := arr[i];
        if (part <> '') then
        begin
          if (vMaxWaitReuse > 0) then WaitSkillReuse(vControl, part, vMaxWaitReuse);
          vControl.UseSkill(part); 
          Delay(10);
        end;
      end;
  end;
function WaitSkillReuse(vControl: TL2Control; vName: String; vMaxWait: Integer): Boolean;
  var
    aSpell: TL2Skill;
  begin
    vControl.GetSkillList.ByName(vName, aSpell);
    if (aSpell.EndTime <= vMaxWait) then delay(aSpell.EndTime);
  end;
procedure setToggle(arr: Array of String; vState: Boolean); Overload;
  var aBuff: TL2Buff; part: String;
  begin
    for part in arr do 
    begin
      if    (User.Buffs.ByName(part, aBuff) and not vState) 
         or (not User.Buffs.ByName(part, aBuff) and vState) 
      then Engine.UseSkill(part);
    end;
  end;
function countMobTargetors(): Integer; Overload;
  begin
    Result := countMobTargetors(User as TL2Live);
  end;
function countMobTargetors(vParam1: TL2Live): Integer; Overload;
  var 
    i, sum: Integer;
    aMob: TL2Npc;
  begin
    sum := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      aMob := NpcList.Items(i);
      if (aMob.Target <> Nil) then Print(aMob.Target.Name);
      if (aMob.Target as TL2Live = vParam1) then sum := sum + 1;
      
    end;
    Result := sum;
  end;
function countMobArround(vRange: Integer = 300): Integer; Overload;
  var 
    i: Integer;
    aMob: TL2Npc;
    aNpcList: TNpcList;
  begin
    Result := 0;
    aNpcList := NpcList;
    for i := 0 to aNpcList.Count - 1 do 
    begin

      aMob := aNpcList.Items(i);
      if ((User.DistTo(aMob) < vRange) and (not aMob.Dead)) then Result := Result + 1;
    end;
  end;
function countMobsInZone(z: Integer = 500): Integer; Overload;
  var 
    i: Integer;
    aMob: TL2Npc;
  begin
    Result := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      aMob := NpcList.Items(i);
      if (aMob.InZone) and (not aMob.Dead) and (Abs(User.Z - aMob.Z) < z) then 
        Result := Result + 1;
    end;
  end;
function countSpoiledMobs(vRange: Integer = 300): Integer; Overload;
  var 
    i: Integer;
    aMob: TL2Npc;
  begin
    Result := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      aMob := NpcList.Items(i);
      if ((User.DistTo(aMob) < vRange) and (aMob.Sweepable)) then Result := Result + 1;
    end;
  end;

function skillReuse(vName: String): Integer; Overload;
  var aSkill: TL2Skill;
  begin
    if SkillList.ByName(vName, aSkill) then Result := aSKill.EndTime
    else 
    begin
      Print('Could not find skill ' + vName + '.');
      Result := 0;
    end;
  end;

function buffCount(arr: Array of String; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(User.Name, arr, time);
  end;
function buffCount(nick: String; arr: Array of String; time: Integer = 60000): Integer; Overload;
  begin
     Result := buffCount(GetControl(nick), arr, time);
  end;
function buffCount(nick: String; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(GetControl(nick),[], time);
  end;
function buffCount(time: Integer = 60000): Integer; Overload; 
  var aBuff: TL2Buff; i: Integer;
  begin
    Result := buffCount(Engine,[], time);
  end;
function buffCount(vControl: TL2Control; arr: Array of String; time: Integer = 60000): Integer; Overload; 
  var aBuff: TL2Buff; LBuffs: TBuffList; i: Integer; 
  begin
    Result := 0;
    LBuffs := vControl.GetUser.Buffs;
    for i := 0 to LBuffs.Count - 1 do
    begin
      aBuff := LBuffs.Items(i);
      if (aBuff.EndTime > time) and ((Length(arr) = 0) or is_in(aBuff.Name, arr))
      then
      begin
        Result := Result + 1;
      end;
    end;
  end;

function buffTime(vID: Integer): Integer; Overload;
  var aBuff: TL2Buff;
  begin
    if User.Buffs.ByID(vID, aBuff) then 
      Result := EndTime(aBuff as TL2Effect)
    else Result := 0;
  end;
function buffTime(vName: String): Integer; Overload;
  var aBuff: TL2Buff;
  begin
    if User.Buffs.ByName(vName, aBuff) then 
      Result := EndTime(aBuff as TL2Effect)
    else Result := 0;
  end;

function EndTime(a: TL2Effect): Integer;
  begin
    Result := a.EndTime;
  end;
function countItems(vID: Integer): Integer; Overload;
  var aItem: TL2Item;
  begin
    if not Inventory.User.ByID(vID, aItem) then 
      Inventory.Quest.ByID(vID, aItem);
    Result := aItem.Count;
  end;
function countItems(vName: String): Integer; Overload;
  var aItem: TL2Item;
  begin
    if not Inventory.User.ByName(vName, aItem) then 
      Inventory.Quest.ByName(vName, aItem);
    Result := aItem.Count;
  end;
function itemCountIs(vID: Integer; count: Integer): Boolean; Overload;
  begin
    Result := countItems(vID) = count;
  end;
function itemCountIs(vName: String; count: Integer): Boolean; Overload;
  begin
    Result := countItems(vName) = count;
  end;

procedure faceControl(face: Integer = -1; combat: Integer = -1; healing: Integer = -1; buffs: Integer = -1; events: Integer = -1);
  var i: Integer;
  begin
    if(combat<>-1) then Engine.FaceControl(1, combat=1);
    if(buffs<>-1) then Engine.FaceControl(2, buffs=1);
    if(healing<>-1) then Engine.FaceControl(3, healing=1);
    if(events<>-1) then Engine.FaceControl(4, events=1);
    if(face<>-1) then Engine.FaceControl(0, face=1);
  end;
end.