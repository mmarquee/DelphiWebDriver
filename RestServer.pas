unit RestServer;

interface

uses
  Vcl.Forms,
  HttpServerCommand,
  IdHTTPServer, IdContext, IdHeaderList, IdCustomHTTPServer,
  classes,
  IdUri,
  System.SysUtils;

type
  TRestServer = Class
  strict private
    FOwner: TComponent;
    FCommand: THttpServerCommand;
    FHttpServer : TIdHTTPServer;
    FOnLogMessage: TOnLogMessage;
  private
    procedure OnCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    //procedure OnCommandOther(ACommand, AData, AVersion, Thread);

    procedure CreatePostStream(AContext: TIdContext; AHeaders: TIdHeaderList;
      var VPostStream: TStream);
    procedure LogMessage(const msg: String);
  public
    constructor Create(AOwner: TComponent);
    procedure Start(port: word);
    property OnLogMessage: TOnLogMessage read FOnLogMessage write FOnLogMessage;
  end;

implementation

uses
  Commands.PostElementElementsCommand,
  Commands.GetTextCommand,
  Commands.ClickElement,
  Commands.PostElements,
  Commands.PostElement,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  Commands;

{ TRestServer }

constructor TRestServer.Create(AOwner: TComponent);
begin
  inherited Create;

  FOwner := AOwner;

  FCommand:= THttpServerCommand.Create(AOwner);

  FCommand.Commands.Register('GET', '/session/(.*)/element/(.*)/text', TGetTextCommand);
//  FCommand.Commands.Register('GET', '/session/(.*)/element/(.*)', TGetElementCommand);
  //FCommand.Commands.Register('GET', '/session/(.*)/screenshot', TGetScreenshotCommand);
  FCommand.Commands.Register('GET', '/session/(.*)/window_handle', TUnimplementedCommand);
  FCommand.Commands.Register('GET', '/session/(.*)/window', TGetWindowCommand);
  FCommand.Commands.Register('GET', '/session/(.*)/title', TGetTitleCommand);
  FCommand.Commands.Register('GET', '/session/(.*)', TGetSessionCommand);
  FCommand.Commands.Register('GET', '/sessions', TGetSessionsCommand);

  FCommand.Commands.Register('GET', '/status', TStatusCommand);


  FCommand.Commands.Register('POST', '/session/(.*)/element/(.*)/click', TClickElementCommand);
  FCommand.Commands.Register('POST', '/session/(.*)/element/(.*)/elements', TPostElementElementsCommand);

  // Avoiding mismatch with patten above
  FCommand.Commands.Register('POST', '/session/(.*)/elements', TPostElementsCommand);
  FCommand.Commands.Register('POST', '/session/(.*)/element', TPostElementCommand);

  FCommand.Commands.Register('POST', '/session/(.*)/timeouts/implicit_wait', TPostImplicitWaitCommand);
  FCommand.Commands.Register('POST', '/session/(.*)/timeouts', TSessionTimeoutsCommand);

  FCommand.Commands.Register('POST', '/session', TCreateSessionCommand);

  // Not sure deletes work!
  FCommand.Commands.Register('DELETE', '/session/(.*)', TDeleteSessionCommand);

  // Just as an example
//  FCommand.Commands.Register('DELETE', '/session/:sessionId', TUnimplementedCommand);

  // Other commands to be implemented later
(*
FCommand.Commands.Register('DELETE', '/session/:sessionId', TDeleteSessionCommand);

FCommand.Commands.Register('POST', '/session/:sessionId/timeouts/async_script', TPostAsyncScriptCommand);
FCommand.Commands.Register('POST', '/session/:sessionId/timeouts/implicit_wait', TPostImplicitWaitCommand);
FCommand.Commands.Register('GET', '/session/:sessionId/window_handle', TGetWindowHandleCommand);
FCommand.Commands.Register('GET', '/session/:sessionId/window_handles', TGetWindowHandlesCommand);

etc.
*)
  FCommand.OnLogMessage := FOnLogMessage;

  FHttpServer := TIdHTTPServer.Create(AOwner);
end;


procedure TRestServer.CreatePostStream(AContext: TIdContext;
  AHeaders: TIdHeaderList; var VPostStream: TStream);
begin
  VPostStream := TStringStream.Create;
end;

procedure TRestServer.LogMessage(const msg: String);
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
  LogMessage('Content-Length: ' + Inttostr(ARequestInfo.ContentLength));
  LogMessage('Content-Type: ' + ARequestInfo.ContentType);
  LogMessage('Host: ' + ARequestInfo.Host);
  LogMessage(ARequestInfo.UserAgent);

  LogMessage(ARequestInfo.Params.CommaText);

  FCommand.CommandGet(AContext, ARequestInfo, AResponseInfo);

  LogMessage('');
  LogMessage('Response: ' + IntToStr(AResponseInfo.ResponseNo));
//  LogMessage('Content-Length:' + Inttostr(AResponseInfo.ContentLength));
  LogMessage('Content-Type: ' + AResponseInfo.ContentType);
  LogMessage(AResponseInfo.ContentText);
end;

procedure TRestServer.Start(port: word);
begin
  FHttpServer.DefaultPort := port;
  FHttpServer.OnCommandGet := OnCommandGet;
  FHttpServer.OnCommandOther := OnCommandGet;
  FHttpServer.OnCreatePostStream := CreatePostStream;
  FHttpServer.Active := True;
end;

end.
