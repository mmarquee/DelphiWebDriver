unit Session;

interface

uses
  JsonAttributeSource,
  System.Classes;

type
  { Will use attributes later, maybe }
  TStatus = class
  public
    [JsonAttribute('sessionId')]
    Guid: String;
    [JsonAttribute('args')]
    Args: String;
    [JsonAttribute('app')]
    App: String;
    [JsonAttribute('platform')]
    Platform: String;

    function ToJsonString: String;
  end;

type
  TSession = class
  private
    FStatus: TStatus;
    FTimeouts: Integer;

    function GetUid: String;
    procedure SetUid(val: String);

  public
    function GetSessionDetails: String;
    function GetSession: String;

    property Uid: String read GetUid write SetUid;
    property Timeouts: Integer write FTimeouts;

    constructor Create(const request: String);
  end;

implementation

uses
  ResourceProcessing,
  System.JSON,
  System.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders;

{ TSession }

constructor TSession.Create;
var
  jsonObj : TJSONObject;
  requestObj : TJSONValue;
  guid: TGuid;
  value: String;

begin
  FStatus:= TStatus.Create;

  if CreateGUID(Guid) <> 0 then
    raise Exception.Create('Unable to generate GUID')
  else
  begin
    // Decode the incoming JSON and see what we have
    jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(request),0) as TJSONObject;
    try
      requestObj := jsonObj.Get('desiredCapabilities').JsonValue;

      (requestObj as TJsonObject).TryGetValue<String>('args', FStatus.Args);
      (requestObj as TJsonObject).TryGetValue<String>('app', FStatus.App);
      (requestObj as TJsonObject).TryGetValue<String>('platformName', FStatus.Platform);

      value := Guid.ToString;
      delete(value,length(value),1);
      delete(value,1,1);

      FStatus.Guid := value;

    finally
      jsonObj.Free;
    end;
  end;
end;

function TSession.GetSession: String;
begin
  result := GetSessionDetails;
end;

function TSession.GetSessionDetails: String;
begin
  result := FStatus.ToJsonString;
end;

function TSession.GetUid: String;
begin
  result := FStatus.Guid;
end;

procedure TSession.SetUid(val: String);
begin
  FStatus.Guid := val;
end;

function TStatus.ToJsonString: String;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;
  uid: String;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject()
      .Add('sessionId', self.Guid)
      .Add('status', 0)
      .BeginObject('value')
        .Add('app', self.App)
        .Add('args', self.Args)
        .Add('platformName', self.Platform)
      .EndObject
    .EndObject;

  result := StringBuilder.ToString;
end;

end.
