unit HostMain;

interface

uses
  RestServer,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FRestServer : TRestServer;
    procedure CreateServer(port: word);
    procedure DestroyServer;
    procedure LogMessage(const msg: String);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  createServer(4723);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  destroyServer;
end;

procedure TForm2.CreateServer(port: word);
begin
  FRestServer := TRestServer.Create(nil);
  FRestServer.OnLogMessage := LogMessage;
  FRestServer.Start(port);
end;

procedure TForm2.DestroyServer;
begin
  FRestServer.Free;
end;

procedure TForm2.LogMessage(const msg: String);
begin
  listbox1.Items.Add(msg);
end;

end.
