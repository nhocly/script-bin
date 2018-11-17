unit sdpITEM;
interface
function doEquip(vID: Integer; newState: Boolean = True): Boolean; Overload;
function doEquip(vName: String; newState: Boolean = True): Boolean; Overload;
function doEquip(vItem: TL2Item; newState: Boolean = True): Boolean; Overload;
implementation
  function doEquip(vID: Integer; newState: Boolean = True): Boolean; Overload;
    var aItem: TL2Item;
    begin
      if (Inventory.User.ByID(vID, aItem)) then Result := doEquip(aItem, newState);
    end;
  function doEquip(vName: String; newState: Boolean = True): Boolean; Overload;
    var aItem: TL2Item;
    begin
      if Inventory.User.ByName(vName, aItem) then Result := doEquip(aItem, newState)
      else 
      begin
        Print('Could not find item ' + vName + '.');
        Result := False;
      end;
    end;
  function doEquip(vItem: TL2Item; newState: Boolean = True): Boolean; Overload;
    begin
      if vItem.Equipped <> newState then Engine.UseItem(vItem);
      Delay(500);
      Result := vItem.Equipped = newState;
    end;
end.