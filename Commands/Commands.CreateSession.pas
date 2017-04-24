unit Commands.CreateSession;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  TCreateSessionCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Commands,
  Session;

procedure TCreateSessionCommand.Execute(AOwner: TForm);
var
  request : String;
  session : TSession;
begin
  request := self.StreamContents;

  session := TSession.Create(request);

  Commands.Sessions.Add(session);

  ResponseJSON(session.GetSessionDetails);
end;

end.
