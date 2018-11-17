unit sdpAUTOFARM;
interface
var
  zone_prefix: String;
  provoke: Array of String;
  mob_range : Integer;
  fighting_toggles : Array of String;
  fighting_buffs: Array of String;
  running_skills: Array of String;

  wait_for_mobs_to_run_in_time: Integer;
  time_to_sweep_mobs_after_killing_them: Integer;
  chill_time: Integer;
  start_killing_mobs_at_percentage_hp: Integer;
function hunt(vNames: Array of String; vUseSkillsAtLast: Boolean = True): Boolean; Overload;
implementation
Uses sdpGPS2, sdpCounter, sdpSTRINGS;
procedure KillMobsThatFollow(vZone: String = '');
  var waitingSince: Integer;
  begin
    waitingSince := GetTickCount;
    useSkills(fighting_buffs);
    setToggle(fighting_toggles, True);
    while (GetTickCount <= waitingSince + wait_for_mobs_to_run_in_time)
      and (user.hp > start_killing_mobs_at_percentage_hp) do delay(100);
    Engine.FaceControl(1, True);
    delay(2000);
    while (not User.Dead) and (countMobArround(mob_range) > 0) do delay(500);
    Engine.FaceControl(1, False);
    setToggle(fighting_toggles, False);
    delay(time_to_sweep_mobs_after_killing_them);
  end;
function hunt(vNames: Array of String; vUseSkillsAtLast: Boolean = True): Boolean; Overload;
  var 
    i: Integer; len: Integer;
  begin
    len := length(vNames) - 1;
    useSkills(running_skills);
    for i := 0 to len do 
    begin
      if not User.Dead then
      begin
        //Print('Going to: ' + zone_prefix + vNames[i]);
        GPS_MoveTo(zone_prefix + vNames[i]);
        if (i < len) or vUseSkillsAtLast then useSkills(provoke);
        if (i = len) then KillMobsThatFollow(vNames[i]);
      end;
    end;
  end;
initialization
  zone_prefix := '';
  provoke := ['Provoke'];
  mob_range := 600;
  fighting_toggles := [''];
  fighting_buffs := [''];
  running_skills := [''];
  
  wait_for_mobs_to_run_in_time := 5000;
  time_to_sweep_mobs_after_killing_them := 2000;
  chill_time := 0;
  start_killing_mobs_at_percentage_hp := 60;
end.

// can be done:
// items for running; items for fighting;
// items for skill usage.