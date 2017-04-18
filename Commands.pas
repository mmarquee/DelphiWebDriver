unit Commands;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TUnimplementedCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TDeleteSessionCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TStatusCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TGetTextCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TCreateSessionCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TGetSessionsCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TGetSessionCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TClickElementCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TGetTitleCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TSessionTimeoutsCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TPostImplicitWaitCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TGetElementCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  TGetWindowCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  windows,
  Sessions,
  Vcl.stdctrls,
  System.Classes,
  System.SysUtils,
  vcl.controls,
  System.JSON,
  System.Types,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  Session;

var
  Sessions: TSessions;

procedure TStatusCommand.Execute(AOwner: TForm);
begin
  try
    ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
  except on e: Exception do
    Error(404);
  end;
end;

procedure TCreateSessionCommand.Execute(AOwner: TForm);
var
  request : String;
  session : TSession;
begin
  request := self.StreamContents;

  session := TSession.Create(request);

  Sessions.Add(session);

  ResponseJSON(session.GetSessionDetails);
end;

procedure TSessionTimeoutsCommand.Execute(AOwner: TForm);
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

procedure TPostImplicitWaitCommand.Execute(AOwner: TForm);
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

  ResponseJSON(Sessions.SetSessionImplicitTimeouts(self.Params[1], StrToInt(value)));
end;

procedure TGetElementCommand.Execute(AOwner: TForm);
begin
  ResponseJSON('{''TGetElementCommand'':'''+ self.Params[1] + '''}');
end;

procedure TGetSessionCommand.Execute(AOwner: TForm);
begin
  try
    ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
  except on e: Exception do
    Error(404);
  end;
end;

procedure TGetSessionsCommand.Execute(AOwner: TForm);
begin
  // No longer correct, needs to be a json array
  ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
end;

procedure TUnimplementedCommand.Execute(AOwner: TForm);
begin
  Error(501);
end;

procedure TGetTitleCommand.Execute(AOwner: TForm);
var
  caption : String;
begin
  // Here we are assuming it is a form
  caption := AOwner.Caption;     // Never gets a caption for some reason
  ResponseJSON(caption);
end;

procedure TGetTextCommand.Execute(AOwner: TForm);
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

procedure TClickElementCommand.Execute(AOwner: TForm);
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

procedure TGetWindowCommand.Execute(AOwner: TForm);
var
  handle : HWND;
begin
  try
    handle := AOwner.Handle;
    ResponseJSON(intToStr(handle));
  except on e: Exception do
    Sessions.ErrorResponse ('7', 'no such element', 'An element could not be located on the page using the given search parameteres');
  end;
end;

procedure TDeleteSessionCommand.Execute(AOwner: TForm);
begin
  try
    // Need to delete it!
    Sessions.DeleteSession(self.Params[1]);

  except on e: Exception do
    Error(404);
  end;
end;

initialization
  Sessions := TSessions.Create;

finalization
  Sessions.Free;

end.
