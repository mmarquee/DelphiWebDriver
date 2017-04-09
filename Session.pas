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

    function GetSessionDetails: String;

  public
    function GetStatus: String;

    function GetSession: String;
    function CreateNewSession(const request: String): String;
    function GetSessions: String;

    constructor Create;
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
begin
end;

function TSession.CreateNewSession(const request: String): String;
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

    result := GetSessionDetails;
  end;
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
        .BeginObject('desiredCapabilities')        // Check this
          .Add('app', self.FApp)
          .Add('args', self.FArgs)
          .Add('platformName', self.FPlatform)
        .EndObject
      .EndObject;

    result := StringBuilder.ToString;

end;

function OSArchitectureToString(arch: TOSVersion.TArchitecture): String;
begin
  case arch of
    arIntelX86: result := 'Intel X86';
    arIntelX64: result := 'Intel X64';
    arArm64: result := 'ARM 64';
    arArm32: result := 'ARM 32';
    else
      result := 'Unknown';
  end;
end;

function TSession.GetSessions: String;
begin
  result := GetSessionDetails; (*AsList*)
end;

function TSession.GetSession: String;
begin
  result := GetSessionDetails;
end;

function TSession.GetStatus: String;
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
    .BeginObject
        .BeginObject('build')
          .Add('version', GetModuleVersion)
          .Add('revision', GetAppRevision)
          .Add('time', 2.1)
        .EndObject
        .BeginObject('os')
          .Add('arch', OSArchitectureToString(TOSVersion.Architecture))
          .Add('name', TOSVersion.Name)
          .Add('version', IntToStr(TOSVersion.Major) + '.' + IntToStr(TOSVersion.Minor))
        .EndObject
    .EndObject;

  result := StringBuilder.ToString;
end;

end.
