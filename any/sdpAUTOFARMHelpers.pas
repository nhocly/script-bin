unit sdpAUTOFARMHelpers;
interface
function ItemCount(vID: Integer): Integer; Overload;
function ItemCount(vName: String): Integer; Overload;
function HasMoreThan(vID: Integer; Amount: Integer = 1): Boolean; Overload;
function HasMoreThan(vName: String; Amount: Integer = 1): Boolean; Overload;
function Alive(): Boolean;
implementation
function ItemCount(vID: Integer): Integer; Overload;
  var
    item: TL2Item;
  begin
    if (Inventory.User.ById(vID, item)) then
      Result := item.Count
    else 
      Result := 0;
  end;
function ItemCount(vName: String): Integer; Overload;
  var
    item: TL2Item;
  begin
    if (Inventory.User.ByName(vName, item)) then
      Result := item.Count
    else 
      Result := 0;
  end;
function HasMoreThan(vID: Integer; Amount: Integer = 1): Boolean; Overload;
  begin
    Result := ItemCount(vID) >= Amount;
  end;
function HasMoreThan(vName: String; Amount: Integer = 1): Boolean; Overload;
  begin
    Result := ItemCount(vName) >= Amount;
  end;
function HasLessThan(vID: Integer; Amount: Integer = 1): Boolean; Overload;
  begin
    Result := ItemCount(vID) <= Amount;
  end;
function HasLessThan(vName: String; Amount: Integer = 1): Boolean; Overload;
  begin
    Result := ItemCount(vName) <= Amount;
  end;

function Alive(): Boolean;
  begin
    Result := not User.Dead;
  end;
initialization
end.