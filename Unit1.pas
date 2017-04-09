unit Unit1;

interface

uses
  RestServer,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FRestServer : TRestServer;
    procedure createServer(port: word);
    procedure destroyServer;
    procedure LogMessage(const msg: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.LogMessage(const msg: String);
begin
  listbox1.Items.Add(msg);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  createServer(4723);

  Button1.enabled := false;
  Button2.enabled := true;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  destroyServer;

  listbox1.Items.Add('Stopping server');

  Button1.enabled := true;
  Button2.enabled := false;
end;

procedure TForm1.createServer(port: word);
begin
  listbox1.Items.Add('Starting server on port ' + IntToStr(port));
  FRestServer := TRestServer.Create(nil);
  FRestServer.OnLogMessage := LogMessage;
  FRestServer.Start(port);
end;

procedure TForm1.destroyServer;
begin
  FRestServer.Free;
end;

end.
