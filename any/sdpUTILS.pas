Unit sdpUTILS;
interface
function QuestStatus(vID: Integer): Integer;
implementation
function QuestStatus(vID: Integer): Integer;
  begin
    Result := 0;
    while not Engine.QuestStatus(vID, Result) and (Result < 100) do
      Result := Result + 1;
    if Result >= 100 then
      Result := -1;
  end;
end.