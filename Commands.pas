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
  TStatusCommand = class(TRESTCommand)
  public
    procedure Execute; override;
  end;

type
  TPostSessionCommand = class(TRESTCommand)
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
  Vcl.Forms,
  Vcl.stdctrls,
  System.Classes,
  Session;

var
  ActiveSession: TSession;

procedure TStatusCommand.Execute;
begin
  ResponseJSON(ActiveSession.GetStatus);
end;

procedure TPostSessionCommand.Execute;
var
  request : String;
begin
  request := self.StreamContents;

  ResponseJSON(ActiveSession.CreateNewSession(request));
end;

procedure TSessionTimeoutsCommand.Execute;
begin
  ResponseJSON('{''sessionTimeout'':''ok''}');
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
  ResponseJSON(ActiveSession.GetSession);
end;

procedure TGetSessionsCommand.Execute;
begin
  ResponseJSON(ActiveSession.GetSessions);
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

initialization
  ActiveSession:= TSession.create;

finalization
  ActiveSession.Free;

end.
