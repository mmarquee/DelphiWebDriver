unit Unit2;

interface

uses
  IdContext, IdCustomHTTPServer,
  HttpServerCommand,
  System.SysUtils, classes;

type
 THttpServerCommand= class (TComponent)
  private
    FCommands: THttpServerCommandRegister;
    function FindCommand(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): boolean;
    procedure SendError(ACmd: TRESTCommandREG;AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo;  E: Exception);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    property Commands: THttpServerCommandRegister read FCommands;
  end;

implementation

{ THttpServerCommand }

function THttpServerCommand.FindCommand(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): boolean;
var
  cmdReg: TRESTCommandREG;
  cmd: TRESTCommand;
  Params: TStringList;
begin
  Params:= TStringList.Create;
  try
    cmdReg:= FCommands.FindCommand(ARequestInfo.Command,ARequestInfo.URI, Params);
    if cmdReg=nil then  exit(false);

    try
      cmd := cmdReg.FCommand.create;
      try
        cmd.Start(cmdReg, AContext, ARequestInfo, AResponseInfo, Params);
        cmd.Execute;
      finally
        cmd.Free;
      end;
    except
      on e:Exception do
      begin
         SendError(cmdReg, AContext, ARequestInfo, AResponseInfo, e);
      end;
    end;
    result:= true;
  finally
    params.Free;
  end;
end;

procedure THttpServerCommand.SendError(ACmd: TRESTCommandREG;
  AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
  AResponseInfo: TIdHTTPResponseInfo; E: Exception);
begin
  AResponseInfo.ResponseNo := 404;
end;

procedure THttpServerCommand.CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if not FindCommand(AContext,ARequestInfo,AResponseInfo) then
    AResponseInfo.ResponseNo := 404;
end;

constructor THttpServerCommand.Create(AOwner: TComponent);
begin
  inherited;
  FCommands:= THttpServerCommandRegister.Create(self);
end;

destructor THttpServerCommand.Destroy;
begin
  FCommands.Free;
  inherited;
end;

end.
