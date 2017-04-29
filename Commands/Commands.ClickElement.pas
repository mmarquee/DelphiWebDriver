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
unit Commands.ClickElement;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'POST', '/session/(.*)/element/(.*)/click'
  ///  </summary>
  TClickElementCommand = class(TRESTCommand)
  private
    procedure ProcessHandle;
    procedure ProcessControlName;
    function OKResponse(const handle: String): String;
  public
    class function GetCommand: String; override;
    class function GetRoute: String; override;

    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Utils,
  System.StrUtils,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,
  Vcl.Controls,
  System.SysUtils,
  System.JSON,
  System.Classes;

procedure TClickElementCommand.ProcessHandle;
var
  ctrl: TWinControl;
  handle: Integer;

begin
  handle := StrToInt(self.Params[2]);
  ctrl := FindControl(handle);

  if (ctrl <> nil) then
  begin
    if (ctrl is TButton) then
    begin
      (ctrl as TButton).click;
    end;

    ResponseJSON(self.OKResponse(self.Params[2]));
  end
  else
    Error(404);
end;

procedure TClickElement.ProcessControlName;
var
  comp: TComponent;
  values : TStringList;

const
  Delimiter = '.';

begin
  if (ContainsText(self.Params[2], Delimiter)) then
  begin
    values := TStringList.Create;
    try
      values.Delimiter := Delimiter;
      values.StrictDelimiter := True;
      values.DelimitedText := self.Params[2];

      // Find parent
      comp := (AOwner.FindComponent(values[0]));

      if comp <> nil then
      begin
        if comp is TPageControl then
        begin
          (comp as TPageControl).ActivePage :=
            (comp as TPageControl).Pages[StrToInt(values[1])];
        end;
      end
      else
        Error(404);
    finally
      values.Free;
    end
  end
  else
  begin
    comp := (AOwner.FindComponent(self.Params[2]));

    if (comp <> nil) then
    begin
      if (comp is TSpeedButton) then
        (comp as TSpeedButton).click
      else if (comp is TToolButton) then
        (comp as TToolButton).click;
        ResponseJSON(self.OKResponse(self.Params[2]));
    end
    else
      Error(404);
  end;
end;

procedure TClickElementCommand.Execute(AOwner: TForm);
begin
  if (isNumber(self.Params[2])) then
    ProcessHandle
  else
    ProcessControlName;
end;

class function TClickElementCommand.GetCommand: String;
begin
  result := 'POST';
end;

class function TClickElementCommand.GetRoute: String;
begin
  result := '/session/(.*)/element/(.*)/click';
end;

function TClickElementCommand.OKResponse(const handle: String): String;
var
  jsonObject: TJSONObject;

begin
  jsonObject := TJSONObject.Create;

  jsonObject.AddPair(TJSONPair.Create('id', handle));

  result := jsonObject.ToString;
end;

end.
