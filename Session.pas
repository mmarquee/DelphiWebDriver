unit Session;

interface

uses
  System.Classes;

type
  TSession = class
  private
    FGuid: TGUID;

    FArgs: String;
    FApp: String;
    FPlatform: String;

    FTimeouts: Integer;

  public
    function GetSessionDetails: String;
    function GetSession: String;

    property Uid: TGUID read FGuid write FGuid;
    property Timeouts: Integer write FTimeouts;

    constructor Create(const request: String);
  end;

implementation

uses
  ResourceProcessing,
  JSON,
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

begin
  if CreateGUID(self.FGuid) <> 0 then
    raise Exception.Create('Unable to generate GUID')
  else
  begin
    // Decode the incoming JSON and see what we have
    jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(request),0) as TJSONObject;
    try
      requestObj := jsonObj.Get('desiredCapabilities').JsonValue;

      (requestObj as TJsonObject).TryGetValue<String>('args', self.FArgs);
      (requestObj as TJsonObject).TryGetValue<String>('app', self.FApp);
      (requestObj as TJsonObject).TryGetValue<String>('platformName', self.FPlatform);
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
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject()
      .Add('sessionID', GUIDToString(FGuid))
      .Add('status', 0)
      .BeginObject('value')
        .Add('app', self.FApp)
        .Add('args', self.FArgs)
        .Add('platformName', self.FPlatform)
      .EndObject
    .EndObject;

  result := StringBuilder.ToString;
end;

end.
