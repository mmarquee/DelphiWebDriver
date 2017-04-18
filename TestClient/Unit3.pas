unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    ListBox1: TListBox;
    btnStartSession: TButton;
    Button1: TButton;
    Button2: TButton;
    StaticText1: TStaticText;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    procedure btnStartSessionClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
  private
    { Private declarations }
    FSessionId: String;

    function Get(const resource: String): string;
    function Delete(const resource: String): string;
    function Post(const resource: String; const parameters: String): string;
    function Sanitize(value: String): String;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  IdHTTP,
  System.JSON,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  System.StrUtils;

{$R *.dfm}

function TForm3.Sanitize(value: String): String;
begin
  value := StringReplace(value,#$A,'',[rfReplaceAll]);
  value := StringReplace(value,#$D,'',[rfReplaceAll]);

  result := value;
end;

function TForm3.Post(const resource: String; const parameters: String): string;
var
  lHTTP: TIdHTTP;
  val : String;
  jsonToSend : TStringStream;
begin
  lHTTP := TIdHTTP.Create(nil);
  lHTTP.Request.ContentType := 'application/json; charset=utf-8';
  try
    val := Sanitize(parameters);
    jsonToSend := TStringStream.create(val, TEncoding.UTF8);
    try
      Result := lHTTP.Post('http://127.0.0.1:4723/' + resource, jsonToSend);
    finally
      jsonToSend.Free;
    end;
  finally
    lHTTP.Free;
  end;
end;

function TForm3.Delete(const resource: String): string;
var
  lHTTP: TIdHTTP;
begin
  lHTTP := TIdHTTP.Create(nil);
  try
    Result := lHTTP.Delete('http://127.0.0.1:4723/' + resource);
  finally
    lHTTP.Free;
  end;
end;

function TForm3.Get(const resource: String): string;
var
  lHTTP: TIdHTTP;
begin
  lHTTP := TIdHTTP.Create(nil);
  try
    Result := lHTTP.Get('http://127.0.0.1:4723/' + resource);
  finally
    lHTTP.Free;
  end;
end;

procedure TForm3.btnStartSessionClick(Sender: TObject);
var
  LJSONValue: TJSONValue;
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;
  Parameters: String;
  result: String;

begin
  FSessionId := '';

  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject
        .BeginObject('desiredCapabilities')
          .Add('platformName', 'iOS')
          .Add('app', 'c:\ProgramData\JHC\F63\Qual\Automation\DealServer2.exe')
          .Add('args', '4099')
        .EndObject
    .EndObject;

  Parameters := StringBuilder.ToString;

  result := Post('session', parameters);

  listBox1.Items.add(result);

  // Decode the JSon
  LJSONValue := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(result),0);
  FSessionID := LJSONValue.GetValue<String>('sessionID');

  StaticText1.Caption := FSessionId;
end;

procedure TForm3.Button10Click(Sender: TObject);
var
  result : String;
begin
  result := post('session/' + self.FSessionId + '/element/Button2/click', '');
end;

procedure TForm3.Button11Click(Sender: TObject);
var
  result : String;
begin
  result := post('session/' + self.FSessionId + '/element/ButtonNotThere/click', '');
  listBox1.Items.add(result);
end;

procedure TForm3.Button12Click(Sender: TObject);
var
  result : String;
begin
  result := Get('session/' + self.FSessionId + '/title');
  listBox1.Items.add(result);
end;

procedure TForm3.Button13Click(Sender: TObject);
var
  result : String;
begin
  result := get('session/' + self.FSessionId + '/element/AutomatedEdit1/text');
  listBox1.Items.add(result);
end;

procedure TForm3.Button14Click(Sender: TObject);
var
  result : String;
begin
  result := Delete('session/ieueihflkjflkjfhe76rj');
  listBox1.Items.add(result);
end;

procedure TForm3.Button15Click(Sender: TObject);
var
  result : String;
begin
  result := Get('session/' + self.FSessionId + '/window');
  listBox1.Items.add(result);
end;

procedure TForm3.Button16Click(Sender: TObject);
var
  result : String;
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;
  Parameters: String;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject
       .Add('using', 'name')
       .Add('value', 'This is Form1 - The Hosting Form')
    .EndObject;

  Parameters := StringBuilder.ToString;

  result := post('session/' + self.FSessionId + '/element', parameters);
  listBox1.Items.add(result);
end;

procedure TForm3.Button17Click(Sender: TObject);
var
  result : String;
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;
  Parameters: String;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject
       .Add('using', 'link text')
       .Add('value', 'Get Title')
    .EndObject;

  Parameters := StringBuilder.ToString;

  result := post('session/' + self.FSessionId + '/element', parameters);
  listBox1.Items.add(result);
end;

procedure TForm3.Button18Click(Sender: TObject);
var
  result : String;
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;
  Parameters: String;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject
       .Add('using', 'name')
       .Add('value', 'Button3')
    .EndObject;

  Parameters := StringBuilder.ToString;

  result := post('session/' + self.FSessionId + '/element', parameters);
  listBox1.Items.add(result);
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  result : String;
begin
  result := Get('status');
  listBox1.Items.add(result);
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  result : String;
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;
  Parameters: String;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject
       .Add('type', 'implicit')
       .Add('ms', '200')
    .EndObject;

  Parameters := StringBuilder.ToString;

  result := post('session/' + self.FSessionId + '/timeouts', parameters);
  listBox1.Items.add(result);
end;

procedure TForm3.Button3Click(Sender: TObject);
var
  result : String;
begin
  result := post('session/' + self.FSessionId + '/timeouts/implicit_wait', '');
  listBox1.Items.add(result);
end;

procedure TForm3.Button4Click(Sender: TObject);
var
  result : String;
begin
  result := get('session/' + self.FSessionId + '/element/btnOK');
  listBox1.Items.add(result);
end;

procedure TForm3.Button5Click(Sender: TObject);
var
  result : String;
begin
  // For example
  result := get('session/' + self.FSessionId);
  listBox1.Items.add(result);
end;

procedure TForm3.Button6Click(Sender: TObject);
var
  result : String;
begin
  result := get('sessions');
  listBox1.Items.add(result);
end;

procedure TForm3.Button7Click(Sender: TObject);
var
  result : String;
begin
  result := get('session/' + self.FSessionId + '/window_handle');
  listBox1.Items.add(result);
end;

procedure TForm3.Button8Click(Sender: TObject);
var
  result : String;
begin
  result := get('error/' + self.FSessionId + '/window_handle');
  listBox1.Items.add(result);
end;

procedure TForm3.Button9Click(Sender: TObject);
var
  result : String;
begin
  result := post('session/' + self.FSessionId + '/element/Button1/click', '');
  listBox1.Items.add(result);
end;

procedure TForm3.DeleteClick(Sender: TObject);
var
  result : String;
begin
  result := Delete('session/' + self.FSessionId);
  listBox1.Items.add(result);
end;

end.
