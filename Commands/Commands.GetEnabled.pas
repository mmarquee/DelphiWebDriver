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
unit Commands.GetEnabled;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'GET' '/session/(.*)/element/(.*)/enabled'
  ///  </summary>
  TGetEnabledCommand = class(TRESTCommand)
  private
    function OKResponse(const SessionID: String; enabled: boolean): String;
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
  Vcl.Grids,
  Vcl.StdCtrls,
  utils;

procedure TGetEnabledCommand.Execute(AOwner: TForm);
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
    OKResponse(self.Params[1], ctrl.Enabled)
  end
  else if (comp <> nil) then
  begin
    if (comp is TSpeedButton) then
      OKResponse(self.Params[1], (comp as TSpeedButton).enabled)
    else if (comp is TLabel) then
      OKResponse(self.Params[1], (comp as TLabel).enabled)
    else if (comp is TStringGrid) then
      OKResponse(self.Params[1], (comp as TStringGrid).enabled);
  end
  else
  begin
    Error(404);
  end;
end;

class function TGetEnabledCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetEnabledCommand.GetRoute: String;
begin
  result := '/session/(.*)/element/(.*)/enabled';
end;

function TGetEnabledCommand.OKResponse(const SessionID: String; enabled: boolean): String;
var
  jsonObject: TJSONObject;

begin
  jsonObject := TJSONObject.Create;

  jsonObject.AddPair(TJSONPair.Create('sessionId', SessionId));
//  jsonObject.AddPair(TJSONPair.Create('status', '0'));
  jsonObject.AddPair(TJSONPair.Create('value', BoolToStr(enabled)));

  result := jsonObject.ToString;
end;

end.
