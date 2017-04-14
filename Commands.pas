unit Commands;

interface

uses
  CommandRegistry,
  HttpServerCommand;

type
  TUnimplementedCommand = class(TRestCommand)
  public
    procedure Execute; override;
  end;

type
  TDeleteSessionCommand = class(TRestCommand)
  public
    procedure Execute; override;
  end;

type
  TStatusCommand = class(TRESTCommand)
  public
    procedure Execute; override;
  end;

type
  TGetTextCommand = class(TRESTCommand)
  public
    procedure Execute; override;
  end;

type
  TCreateSessionCommand = class(TRESTCommand)
  public
    procedure Execute; override;
  end;

type
  TGetSessionsCommand = class(TRESTCommand)
  public
    procedure Execute; override;
  end;

type
  TGetSessionCommand = class(TRESTCommand)
  public
    procedure Execute; override;
  end;

type
  TClickElementCommand = class(TRESTCommand)
  public
    procedure Execute; override;
  end;

type
  TGetTitleCommand = class(TRestCommand)
  public
    procedure Execute; override;
  end;

type
  TSessionTimeoutsCommand = class(TRESTCommand)
  public
    procedure Execute; override;
  end;

type
  TPostImplicitWaitCommand = class(TRestCommand)
  public
    procedure Execute; override;
  end;

type
  TGetElementCommand = class(TRestCommand)
  public
    procedure Execute; override;
  end;

implementation

uses
  generics.collections,
  Vcl.Forms,
  Vcl.stdctrls,
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Types,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  Session;

Type
  TSessions = class
  strict private
    FSessions: TObjectList<TSession>;
  public
    constructor Create;
    destructor Destroy;

    function GetSession(sessionId: String): TSession;
    function GetSessionStatus(sessionId: String): String;
    procedure DeleteSession(sessionId: String);
    procedure Add(session: TSession);
    function SetSessionTimeouts(sessionId: String; ms: integer): String;
    function Count: Integer;
  end;

var
  Sessions: TSessions;

procedure TStatusCommand.Execute;
begin
  try
    ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
  except on e: Exception do
    Error(404);
  end;
end;

procedure TCreateSessionCommand.Execute;
var
  request : String;
  session : TSession;
begin
  request := self.StreamContents;

  session := TSession.Create(request);

  Sessions.Add(session);

  ResponseJSON(session.GetSessionDetails);
end;

procedure TSessionTimeoutsCommand.Execute;
var
  jsonObj : TJSONObject;
  requestType: String;
  value: String;

begin
  // Set timeout for the session

  // Decode the incoming JSON and see what we have
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('type', requestType);
    (jsonObj as TJsonObject).TryGetValue<String>('ms', value);
  finally
    jsonObj.Free;
  end;

  ResponseJSON(Sessions.SetSessionTimeouts(self.Params[1], StrToInt(value)));
end;

procedure TPostImplicitWaitCommand.Execute;
begin
  ResponseJSON('{''TPostImplicitWaitCommand'':''ok''}');
end;

procedure TGetElementCommand.Execute;
begin
  ResponseJSON('{''TGetElementCommand'':'''+ self.Params[1] + '''}');
end;

procedure TGetSessionCommand.Execute;
begin
  try
    ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
  except on e: Exception do
    Error(404);
  end;
end;

procedure TGetSessionsCommand.Execute;
begin
  // No longer correct, needs to be a json array
  ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
end;

procedure TUnimplementedCommand.Execute;
begin
  Error(501);
end;

procedure TGetTitleCommand.Execute;
var
  caption : String;
begin
  // Here we are assuming it is a form
  caption := (self.Reg.FHost as TForm).Caption;
  ResponseJSON(caption);
end;

procedure TGetTextCommand.Execute;
var
  comp: TComponent;
begin

  comp := (self.Reg.FHost.FindComponent(self.Params[2]));

  if (comp <> nil) then
  begin
    // Something like this?
    ResponseJSON((comp as TEdit).Text);
  end
  else
    Error(404);
end;

procedure TClickElementCommand.Execute;
var
  comp: TComponent;
begin

  comp := (self.Reg.FHost.FindComponent(self.Params[2]));

  if (comp <> nil) then
  begin
    // Something like this?
    (comp as TButton).click;
  end
  else
    Error(404);
end;

procedure TDeleteSessionCommand.Execute;
begin
// Find session and delete it.
  try
    // Need to delete it!
    //ResponseJSON(GetSessionStatus(self.Params[1]));
    Sessions.DeleteSession(self.Params[1]);

  except on e: Exception do
    Error(404);
  end;
end;

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

function TSessions.GetSession(sessionId: String): TSession;
var
  i : integer;

begin
  // Probably a better way of doing this!
  result := nil;

  for i := 0 to Sessions.Count -1 do
  begin
    if FSessions[i].Uid = TGUID.Create(sessionId) then
    begin
      result := FSessions[i];
      break;
    end;
  end;

  if result = nil then
    raise Exception.create('Cannot find session');
end;

function TSessions.SetSessionTimeouts(sessionId: String; ms: integer): String;
var
  i : integer;
  found : boolean;
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;

begin
  found := false;

  // Probably a better way of doing this!
  for i := 0 to Sessions.Count -1 do
  begin
    if FSessions[i].Uid = TGUID.Create(sessionId) then
    begin
      // Dodgy
      found := true;
      FSessions[i].Timeouts := ms;
      break;
    end;
  end;

  if not found then
    raise Exception.create('Cannot find session');

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

function TSessions.GetSessionStatus(sessionId: String) : String;
begin
  result := GetSession(sessionId).GetStatus;
end;

function TSessions.Count: Integer;
begin
  result := FSessions.Count;
end;

procedure TSessions.Add(session: TSession);
begin
  FSessions.Add(session);
end;

procedure TSessions.DeleteSession(sessionId: String);
var
  i : integer;
  found : boolean;
begin
  found := false;

  // Probably a better way of doing this!
  for i := 0 to Sessions.Count -1 do
  begin
    if FSessions[i].Uid = TGUID.Create(sessionId) then
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

initialization
//  Sessions:= TObjectList<TSession>.create;
  Sessions := TSessions.Create;
finalization
  Sessions.Free;

end.
