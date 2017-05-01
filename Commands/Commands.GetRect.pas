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
unit Commands.GetRect;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'GET' '/session/(.*)/element/(.*)/rect'
  ///  </summary>
  TGetRectCommand = class(TRESTCommand)
  private
    function OKResponse(const sessionId: String; x, y, width, height: Integer): String;
  public
    class function GetCommand: String; override;
    class function GetRoute: String; override;

    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Vcl.Controls,
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.JSON,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  Vcl.Buttons,
  Vcl.StdCtrls,
  utils;

procedure TGetRectCommand.Execute(AOwner: TForm);
var
  comp: TComponent;
  ctrl: TWinControl;
  handle: Integer;

begin
  ctrl := nil;
  comp := nil;

  if (isNumber(self.Params[2])) then
  begin
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);
  end
  else
    comp := AOwner.FindComponent(self.Params[2]);

  // Needs to actually be proper rect
  if (ctrl <> nil) then
  begin
    ResponseJSON(OKResponse(self.Params[1], ctrl.top, ctrl.left, ctrl.width, ctrl.height))
  end
// Not possible for components?
//  else if (comp <> nil) then
//  begin
//    ResponseJSON(OKResponse(self.Params[1], comp.top, comp.left, comp.width, comp.height))
//  end
  else
  begin
    Error(404);
  end;
end;

class function TGetRectCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetRectCommand.GetRoute: String;
begin
  result := '/session/(.*)/element/(.*)/rect';
end;

function TGetRectCommand.OKResponse(const sessionId: String; x, y, width, height: Integer): String;
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
      .Add('sessionId', sessionId)
      .Add('status', 0)
      .Add('x', x)
      .Add('y', y)
      .Add('width', width)
      .Add('height', height)
    .EndObject;

  result := StringBuilder.ToString;
end;

end.
