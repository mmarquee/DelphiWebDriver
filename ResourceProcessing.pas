unit ResourceProcessing;

interface

function GetModuleVersion: String;
function GetAppRevision: String;

implementation

uses
  System.Types,
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  Winapi.Windows;

// via http://stackoverflow.com/questions/10854958/how-to-get-version-of-running-executable
function GetFullModuleVersion(Instance: THandle; out iMajor, iMinor, iRelease, iBuild: Integer): Boolean;
var
  fileInformation: PVSFIXEDFILEINFO;
  verlen: Cardinal;
  rs: TResourceStream;
  m: TMemoryStream;
begin
  if Instance = 0 then
    Instance := HInstance;

  FindResource(Instance, MAKEINTRESOURCE(100), RT_VERSION);

  m := TMemoryStream.Create;
  try
    rs := TResourceStream.CreateFromID(Instance, 1, RT_VERSION);
    try
      m.CopyFrom(rs, rs.Size);
    finally
      rs.Free;
    end;

    m.Position:=0;
    if not VerQueryValue(m.Memory, '\', (*var*)Pointer(fileInformation), (*var*)verlen) then
    begin
      iMajor := 0;
      iMinor := 0;
      iRelease := 0;
      iBuild := 0;
      Exit(false);
    end;

    iMajor := fileInformation.dwFileVersionMS shr 16;
    iMinor := fileInformation.dwFileVersionMS and $FFFF;
    iRelease := fileInformation.dwFileVersionLS shr 16;
    iBuild := fileInformation.dwFileVersionLS and $FFFF;
  finally
    m.Free;
  end;

  Result := True;
end;

function GetModuleVersion: String;
var
  minor, major, release, build : integer;
begin
  GetFullModuleVersion (0, major, minor, release, build);

  result := Format('%d.%d', [major, minor]);
end;

function GetAppRevision: String;
var
  minor, major, release, build : integer;
begin
  GetFullModuleVersion (0, major, minor, release, build);

  result := Format('%d.%d', [release, build]);
end;

end.
