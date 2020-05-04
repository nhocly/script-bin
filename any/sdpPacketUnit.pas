unit sdpPacketUnit;

interface

type TNetworkPacket = class
  public
    Current: Integer;
    constructor Create(pData: PChar; vDataSize: Word); overload;
    constructor Create(); overload;
    procedure Write64(value: Int64);      // WriteQ
    procedure Write32(value: Cardinal);   // WriteD
    procedure Write16(value: Word);       // WriteH
    procedure Write8(value: Byte);        // WriteC
    procedure WriteString(value: String); // WriteS
    function Read64(): Int64;             // ReadQ, Q = ??
    function Read32(): Cardinal;          // ReadD, D = ??
    function Read16(): Word;              // ReadH, H = ??
    function Read8(): Byte;               // ReadC, C = ??
    function ReadString(): String;        // ReadS, S = String
    function ToHex(): String;
    function SendToServer(vControl: TL2Control): Boolean;
    function SendToClient(vControl: TL2Control): Boolean;
    
    function Done(): Boolean;
    procedure Skip(amount: Integer);
  private
    dataSize: Word;
    data: Array[0..10240] of Byte;
  end;


implementation
uses SysUtils;
constructor TNetworkPacket.Create(pData: PChar; vDataSize: Word);
  begin
    inherited Create;
    self.dataSize := vDataSize;
    Move(pData^, PChar(@data[0])^, vDataSize);
  end;

constructor TNetworkPacket.Create();
  begin
    inherited Create;
  end;

function TNetworkPacket.Read64;
  begin
    Result:= PInt64(@data[Current])^;
    Current:= Current + SizeOf(Int64);
  end;

function TNetworkPacket.Read32;
  begin
    Result:= PCardinal(@data[Current])^;
    Current:= Current + SizeOf(Cardinal);
  end;

function TNetworkPacket.Read16;
  begin
    Result:= PWord(@data[Current])^;
    Current:= Current + SizeOf(Word);
  end;

function TNetworkPacket.Read8;
  begin
    Result:= PByte(@data[Current])^;
    Current:= Current + SizeOf(Byte);
  end;

function TNetworkPacket.ReadString;
  begin
    Result:= String(PChar(@data[Current]));
    Current:= Current + (Length(Result) + 1) * SizeOf(Char);
  end;

procedure TNetworkPacket.Write64;
  begin
    (PInt64(@data[Current])^):= value;
    Current:= Current + SizeOf(Int64);
  end;

procedure TNetworkPacket.Write32;
  begin
    (PCardinal(@data[Current])^):= value;
    Current:= Current + SizeOf(Cardinal);
  end;

procedure TNetworkPacket.Write16;
  begin
    (PWord(@data[Current])^):= value;
    Current:= Current + SizeOf(Word);
  end;

procedure TNetworkPacket.Write8;
  begin
    (PByte(@data[Current])^):= value;
    Current:= Current + SizeOf(Byte);
  end;

procedure TNetworkPacket.WriteString;
  begin
    Move(value^, PChar(@data[Current])^, (Length(value) + 1) * SizeOf(Char));
    Current:= Current + (Length(value) + 1) * SizeOf(Char);
  end;

function TNetworkPacket.ToHex;
  var i: Cardinal;
  begin
    Result:= '';
    for i:= 0 to Current-1 do 
      Result:= Result + IntToHex(data[i], 2);
  end;

function TNetworkPacket.SendToServer;
  begin
    vControl.SendToServer(Self.ToHex);
  end;

function TNetworkPacket.SendToClient;
  begin
    vControl.SendToClient(Self.ToHex);
  end;


function TNetworkPacket.Done(): Boolean;
  begin
    Result := dataSize <= Current;
  end;
procedure TNetworkPacket.Skip(amount: Integer);
  begin
    self.Current := self.Current + amount;
  end;
end.