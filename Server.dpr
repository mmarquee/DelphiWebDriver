program Server;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  RestServer in 'RestServer.pas',
  CommandRegistry in 'CommandRegistry.pas',
  Commands in 'Commands.pas',
  Session in 'Session.pas',
  HttpServerCommand in 'HttpServerCommand.pas',
  ResourceProcessing in 'ResourceProcessing.pas',
  Sessions in 'Sessions.pas',
  JsonAttributeSource in 'JsonAttributeSource.pas',
  Commands.PostElement in 'Commands.PostElement.pas',
  Commands.PostElements in 'Commands.PostElements.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
