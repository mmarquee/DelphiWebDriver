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
  Commands.GetWindowHandle,
  Commands.DeleteSession,
  Commands.PostElementElements,
  Commands.PostExecute,
  Commands.GetElementValue,
  Commands.GetAlertText,
  Commands.PostClear,
  Commands.GetText,
  Commands.ClickElement,
  Commands.GetRect,
  Commands.PostElements,
  Commands.PostElement,
  Commands.CreateSession,
  Commands.DismissAlert,
  Commands.AcceptAlert,
  Commands.GetEnabled,
  Commands.GetScreenshot,
  Commands.GetElementScreenshot,
  Commands.PostValue,
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

  FCommand.Commands.Register(TGetElementValueCommand);

  FCommand.Commands.Register(TGetEnabledCommand);          // '/session/(.*)/element/(.*)/enabled'
  FCommand.Commands.Register(TGetRectCommand);             // '/session/(.*)/element/(.*)/rect'
  FCommand.Commands.Register(TGetTextCommand);             // '/session/(.*)/element/(.*)/text'
  FCommand.Commands.Register(TGetElementScreenshotCommand);// '/session/(.*)/screenshot/(.*)'
  FCommand.Commands.Register(TGetScreenshotCommand);       // '/session/(.*)/screenshot'
  FCommand.Commands.Register(TGetWindowhandleCommand);     // '/session/(.*)/window_handle'
  FCommand.Commands.Register(TGetWindowCommand);           // '/session/(.*)/window'
  FCommand.Commands.Register(TGetTitleCommand);            // '/session/(.*)/title'
  FCommand.Commands.Register(TGetAlertTextCommand);        // '/session/(.*)/alert_text';

  FCommand.Commands.Register(TGetSessionCommand);          // '/session/(.*)'

  FCommand.Commands.Register(TDismissAlertCommand);        // '/session/(.*)/dismiss_alert';
  FCommand.Commands.Register(TAcceptAlertCommand);         // '/session/(.*)/accept_alert';

  FCommand.Commands.Register(TGetSessionsCommand);

  FCommand.Commands.Register(TStatusCommand);
  FCommand.Commands.Register(TPostValueCommand);
  FCommand.Commands.Register(TPostClearCommand);
  FCommand.Commands.Register(TClickElementCommand);
  FCommand.Commands.Register(TPostElementElementsCommand);

  // Avoiding mismatch with pattern above
  FCommand.Commands.Register(TPostElementsCommand);
  FCommand.Commands.Register(TPostElementCommand);
  FCommand.Commands.Register(TPostExecuteCommand);
  FCommand.Commands.Register(TPostImplicitWaitCommand);
  FCommand.Commands.Register(TSessionTimeoutsCommand);
  FCommand.Commands.Register(TCreateSessionCommand);
  FCommand.Commands.Register(TDeleteSessionCommand);

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
