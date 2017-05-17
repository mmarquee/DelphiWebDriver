{***************************************************************************}
{                                                                           }
{           DelphiWebDriver                                                 }
{                                                                           }
{           Copyright 2017 inpwtepydjuf@gmail.com                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}
unit Commands.GetElementScreenshot;

interface

uses
  Vcl.Forms,
  Vcl.Graphics,
  CommandRegistry,
  HttpServerCommand;

type
  TGetElementScreenshotCommand = class(TRestCommand)
  private
    function OKResponse(const session: String; value: Vcl.Graphics.TBitmap): String;
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

implementation

uses
  Commands,
  Vcl.Controls,
  System.Classes,
  Winapi.Windows,
  System.JSON,
  System.JSON.Types,
  System.JSON.Writers,
  System.SysUtils,
  System.JSON.Builders,
  utils;

class function TGetElementScreenshotCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetElementScreenshotCommand.GetRoute: String;
begin
  result := '/session/(.*)/element/screenshot/(.*)';
end;

procedure TGetElementScreenshotCommand.Execute(AOwner: TForm);
var
  Bmp: Vcl.Graphics.TBitmap;
  Win: HWND;
  ctrl: TWinControl;
  handle: Integer;

begin
  if (isNumber(self.Params[2])) then
  begin
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);

    bmp := Vcl.Graphics.TBitmap.Create;
    try
      bmp := TakeScreenshot(ctrl.Handle);

      ResponseJSON(self.OKResponse(self.Params[2], bmp));
    finally
      bmp.Free;
    end;
  end
  else
  begin
    Commands.Sessions.ErrorResponse ('7', 'no such element', 'An element could not be located on the page using the given search parameteres');
  end;
end;

function TGetElementScreenshotCommand.OKResponse(const session: String; value: Vcl.Graphics.TBitmap): String;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;
  val: String;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  val := BitmapToBase64(value);

  Builder
    .BeginObject()
      .Add('sessionId', session)
      .Add('status', 0)
      .Add('value', BitmapToBase64(value))
    .EndObject;

  result := StringBuilder.ToString;
end;

end.

