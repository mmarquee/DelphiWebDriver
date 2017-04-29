unit Sessions;

interface

uses
  generics.collections,
  Session;

Type
  TSessions = class
  strict private
    FSessions: TObjectList<TSession>;
  public
    constructor Create;
    destructor Destroy; override;

    function GetSession(const sessionId: String): TSession;
    function GetSessionStatus(const sessionId: String): String;
    procedure DeleteSession(const sessionId: String);
    procedure Add(session: TSession);
    function SetSessionTimeouts(const sessionId: String; ms: integer): String;
    function SetSessionImplicitTimeouts(const sessionId: String; ms: integer): String;
    function Count: Integer;
    function GetStatus: String;

    function OKResponse(const sessionId: String): String;
    function ErrorResponse(const sessionId, code, msg: String): String;

    function FindElement(const sessionId: String): String;
  end;

implementation

uses
  System.StrUtils,
  System.JSON.Types,
  System.Classes,
  System.JSON.Writers,
  System.JSON.Builders,
  System.SysUtils,
  ResourceProcessing;

{ TSessions }

constructor TSessions.Create;
begin
  inherited;
  FSessions:= TObjectList<TSession>.create;
end;

destructor TSessions.Destroy;
begin
  FSessions.Free;
  inherited;
end;

function TSessions.GetSession(const sessionId: String): TSession;
var
  i : integer;

begin
  // Probably a better way of doing this!
  result := nil;

  for i := 0 to FSessions.Count -1 do
  begin
    if FSessions[i].Uid = sessionId then
    begin
      result := FSessions[i];
      break;
    end;
  end;

  if result = nil then
    raise Exception.create('Cannot find session');
end;

function TSessions.SetSessionImplicitTimeouts(const sessionId: String; ms: integer): String;
var
  i : integer;
  found : boolean;

begin
  found := false;

  // Probably a better way of doing this!
  for i := 0 to FSessions.Count -1 do
  begin
    if FSessions[i].Uid = sessionId then
    begin
      // Dodgy
      found := true;
      FSessions[i].Timeouts := ms;
      break;
    end;
  end;

  if not found then
    raise Exception.create('Cannot find session');

  result := self.OKResponse(sessionId);
end;

function TSessions.SetSessionTimeouts(const sessionId: String; ms: integer): String;
var
  i : integer;
  found : boolean;

begin
  found := false;

  // Probably a better way of doing this!
  for i := 0 to FSessions.Count -1 do
  begin
    if FSessions[i].Uid = sessionId then
    begin
      // Dodgy
      found := true;
      FSessions[i].Timeouts := ms;
      break;
    end;
  end;

  if not found then
    raise Exception.create('Cannot find session');

  result := self.OKResponse(sessionId);
end;

function TSessions.ErrorResponse(const sessionId, code, msg: String): String;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;

begin
  // Construct reply
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject()
      .Add('sessionID', sessionId)
      .Add('status', code)
      .BeginObject('value')
        .Add('error', code)
        .Add('message', code)
      .EndObject
    .EndObject;

  result := StringBuilder.ToString;
end;

function TSessions.OKResponse(const sessionId: String): String;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;

begin
  // Construct reply
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject()
      .Add('sessionID', sessionId)
      .Add('status', 0)
    .EndObject;

  result := StringBuilder.ToString;
end;

function TSessions.GetSessionStatus(const sessionId: String) : String;
begin
  result := self.GetStatus;
end;

function TSessions.Count: Integer;
begin
  result := FSessions.Count;
end;

procedure TSessions.Add(session: TSession);
begin
  FSessions.Add(session);
end;

procedure TSessions.DeleteSession(const sessionId: String);
var
  i : integer;
  found : boolean;
begin
  found := false;

  // Probably a better way of doing this!
  for i := 0 to FSessions.Count -1 do
  begin
    if FSessions[i].Uid = sessionId then
    begin
      // Dodgy
      found := true;
      FSessions.Delete(i);
      break;
    end;
  end;

  if not found then
    raise Exception.create('Cannot find session');
end;

function OSArchitectureToString(arch: TOSVersion.TArchitecture): String;
begin
  case arch of
    arIntelX86: result := 'Intel X86';
    arIntelX64: result := 'Intel X64';
    arArm64: result := 'ARM 64';
    arArm32: result := 'ARM 32';
    else
      result := 'Unknown';
  end;
end;

function TSessions.FindElement(const sessionId: String): String;
begin
  result := 'N/A';
  //comp := (self.Reg.FHost.FindComponent(self.Params[2]));
end;

function TSessions.GetStatus: String;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject
        .BeginObject('build')
          .Add('version', GetModuleVersion)
          .Add('revision', GetAppRevision)
          .Add('time', 2.1)
        .EndObject
        .BeginObject('os')
          .Add('arch', OSArchitectureToString(TOSVersion.Architecture))
          .Add('name', TOSVersion.Name)
          .Add('version', IntToStr(TOSVersion.Major) + '.' + IntToStr(TOSVersion.Minor))
        .EndObject
    .EndObject;

  result := StringBuilder.ToString;
end;

end.
