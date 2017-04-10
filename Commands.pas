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

procedure TClickElementCommand.Execute;
begin

end;

initialization
  ActiveSession:= TSession.create;

finalization
  ActiveSession.Free;

end.
