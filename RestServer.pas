unit RestServer;

interface

uses
  HttpServerCommand,
  IdHTTPServer, IdContext, IdHeaderList, IdCustomHTTPServer,
  classes,
  IdUri,
  System.SysUtils;

type
  TOnLogMessage = procedure (const msg: String) of Object;

type
  TRestServer = Class
  strict private
    FCommand: THttpServerCommand;
    FHttpServer : TIdHTTPServer;
    FOnLogMessage: TOnLogMessage;
  private
    procedure OnCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure CreatePostStream(AContext: TIdContext; AHeaders: TIdHeaderList;
      var VPostStream: TStream);
    procedure LogMessage(msg: String);
  public
    constructor Create(AOwner: TComponent);
    procedure Start(port: word);
    property OnLogMessage: TOnLogMessage read FOnLogMessage write FOnLogMessage;
  end;

implementation

uses
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  Commands;

{ TRestServer }

constructor TRestServer.Create(AOwner: TComponent);
begin
  inherited Create;

  FCommand:= THttpServerCommand.Create(AOwner);



  FCommand.Commands.Register('GET', '/session/(.*)/element/(.*)', TGetElementCommand);
  //FCommand.Commands.Register('GET', '/session/(.*)/screenshot', TGetScreenshotCommand);
  FCommand.Commands.Register('GET', '/session/(.*)/window_handle', TUnimplementedCommand);
  FCommand.Commands.Register('GET', '/session/(.*)', TGetSessionCommand);
  FCommand.Commands.Register('GET', '/sessions', TGetSessionsCommand);

  FCommand.Commands.Register('GET', '/status', TStatusCommand);

  FCommand.Commands.Register('POST', '/session/(.*)/element/(.*)/click', TClickElementCommand);
  FCommand.Commands.Register('POST', '/session/(.*)/timeouts/implicit_wait', TPostImplicitWaitCommand);
  FCommand.Commands.Register('POST', '/session/(.*)/timeouts', TSessionTimeoutsCommand);

  FCommand.Commands.Register('POST', '/session', TPostSessionCommand);

  // Just as an example
  FCommand.Commands.Register('DELETE', '/session/:sessionId', TUnimplementedCommand);

  // Other commands to be implemented later
(*
FCommand.Commands.Register('DELETE', '/session/:sessionId', TDeleteSessionCommand);

FCommand.Commands.Register('POST', '/session/:sessionId/timeouts/async_script', TPostAsyncScriptCommand);
FCommand.Commands.Register('POST', '/session/:sessionId/timeouts/implicit_wait', TPostImplicitWaitCommand);
FCommand.Commands.Register('GET', '/session/:sessionId/window_handle', TGetWindowHandleCommand);
FCommand.Commands.Register('GET', '/session/:sessionId/window_handles', TGetWindowHandlesCommand);

etc.
*)


  FHttpServer := TIdHTTPServer.Create(AOwner);
end;


procedure TRestServer.CreatePostStream(AContext: TIdContext;
  AHeaders: TIdHeaderList; var VPostStream: TStream);
begin
  VPostStream := TStringStream.Create;
end;

procedure TRestServer.LogMessage(msg: String);
begin
  if assigned(FOnLogMessage) then
    OnLogMessage(msg);
end;

procedure TRestServer.OnCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  cmd: String;

begin
  cmd := ARequestInfo.Command;

  LogMessage('===================================================');
  LogMessage(ARequestInfo.Command + ' ' +  ARequestInfo.uri + ' ' + ARequestInfo.Version);
  LogMessage('Accept-Encoding: ' + ARequestInfo.AcceptEncoding);
  LogMessage('Connection: ' + ARequestInfo.Connection);
  LogMessage('Content-Length:' + Inttostr(ARequestInfo.ContentLength));
  LogMessage('Content-Type:' + ARequestInfo.ContentType);
  LogMessage('Host:' + ARequestInfo.Host);
  LogMessage(ARequestInfo.UserAgent);

  LogMessage(ARequestInfo.Params.CommaText);

  FCommand.CommandGet(AContext, ARequestInfo, AResponseInfo);
end;

procedure TRestServer.Start(port: word);
begin
  FHttpServer.DefaultPort := port;
  FHttpServer.OnCommandGet := OnCommandGet;
  FHttpServer.OnCreatePostStream := CreatePostStream;
  FHttpServer.Active := True;
end;

end.
