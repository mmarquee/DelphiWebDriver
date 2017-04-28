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
    function OKResponse(x, y, width, height: Integer): String;
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
    if (ctrl is TEdit) then
    begin
      ResponseJSON((ctrl as TEdit).Text)
    end;
  end
  else if (comp <> nil) then
  begin
    if (comp is TSpeedButton) then
    begin
      ResponseJSON((comp as TSpeedButton).Caption);
    end;
  end
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

function TGetRectCommand.OKResponse(x, y, width, height: Integer): String;
var
  jsonObject: TJSONObject;

begin
  jsonObject := TJSONObject.Create;

  jsonObject.AddPair(TJSONPair.Create('x', IntToStr(x)));
  jsonObject.AddPair(TJSONPair.Create('y', IntToStr(y)));
  jsonObject.AddPair(TJSONPair.Create('width', IntToStr(width)));
  jsonObject.AddPair(TJSONPair.Create('height', IntToStr(height)));

  result := jsonObject.ToString;
end;

end.
