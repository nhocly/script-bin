// TODO:
// kamael check buff and buff if possible at spot.

const
  party_leader= 'boomboompow';
  total_number_of_kamaels=7;
  nicks_of_kamaels: array of String = ['kam4','kam1','kam2','kam3','kam5','kam6','kam7'];
  
  // '20 11111'- RedMoon unlock password = 11111;
  unlock_bypass: String = '20 11111';
  // 1476 - Appetite of Destruction;
  // 1477 - Vampiric Impulse;
  // 1478 - Protection Instinct;
  // 1479 - Magic Impulse; 
  buff_to_do: array of Integer = [1479];
  
procedure corect_possition(); begin
  Engine.MoveTo(149368, 115016, -5456);
end;
  
///////////////////////////////////////////
// Do not change anything after this point.
///////////////////////////////////////////

var
  i: Integer = 0;
  control: TL2Control = GetControl(party_leader);
  buff: TL2Buff;
  skill: TL2Skill;
  part: Integer;

begin
  while control.Status = TL2Status(lsOnline) do begin
    if (Engine.Status = TL2Status(lsOffline)) then begin      // if restart screen
      Engine.GameStart(i);                  // login
      Engine.ByPassToServer(unlock_bypass); // unlock
    end;
    repeat
      corect_possition;
      control.InviteParty(nicks_of_kamaels[i], TLootType(ldLooter));
      Engine.LoadConfig('kam');
      Engine.FaceControl(0, True);
      delay(750);
    Until (Engine.GetParty.Leader.Name = party_leader);
    for part in buff_to_do do begin
      while control.GetUser.Buffs.ByID(1479, buff)
        and (buff.EndTime > 2) do delay(50);
      while Engine.GetSkillList.ByID(part, skill)
        and (skill.EndTime > 0) do begin
          delay(50);
          Print('skill reuse');
        end;
      While not User.InRange(control.getUser.x, control.getUser.y, control.getUser.z, 999, 400) do begin
        Print('Party leader too far.');
        delay(100);
      end;
      Engine.UseSkill(part);
      Engine.UseSkill(1478);
      Print('useskill');
      Delay(250);
    end;
    Engine.Restart();
    i := i + 1;
    if (i >= total_number_of_kamaels) then i := 0;
  end; // while 
end.
