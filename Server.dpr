program Server;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  RestServer in 'RestServer.pas',
  HttpServerCommand in 'HttpServerCommand.pas',
  Commands in 'Commands.pas',
  Session in 'Session.pas',
  Unit2 in 'Unit2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
