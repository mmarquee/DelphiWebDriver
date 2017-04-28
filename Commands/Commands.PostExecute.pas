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
unit Commands.PostExecute;

interface

uses
  Sessions,
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles POST /session/{sessionId}/execute
  ///  </summary>
  ///  <remarks>
  ///  Only for certain specific controls - StringGrids and ToolButtons
  ///  </remarks>
  TPostExecuteCommand = class(TRestCommand)
  private
    /// <summary>
    ///  Right click on the control
    /// </summary>
    /// <remarks>
    ///  Currently only implemented for some controls
    /// </remarks>
    procedure RightClick (AOwner: TForm; Const control: String);

    /// <summary>
    ///  Right click on the control
    /// </summary>
    /// <remarks>
    ///  Currently only implemented for some controls
    /// </remarks>
    procedure LeftClick (AOwner: TForm; Const control: String);

        /// <summary>
    ///  Right click on the control
    /// </summary>
    /// <remarks>
    ///  Currently only implemented for some controls
    /// </remarks>
    procedure DoubleClick (AOwner: TForm; Const control: String);

    function OKResponse(const sessionId, control: String): String;
  public
    class function GetCommand: String; override;
    class function GetRoute: String; override;

    /// <summary>
    ///  Highjacked for left and right clicks on controls
    /// </summary>
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Vcl.ComCtrls,
  System.StrUtils,
  System.SysUtils,
  Vcl.Grids,
  System.Classes,
  System.JSON;

procedure TPostExecuteCommand.Execute(AOwner: TForm);
var
  jsonObj : TJSONObject;
  argsObj : TJsonValue;
  script: String;
  control: String;

begin
  // Decode the incoming JSON and see what we have
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('script', script);
    //(jsonObj as TJsonObject).TryGetValue<String>('args', value);
     argsObj := jsonObj.Get('args').JsonValue;

    (argsObj as TJsonObject).TryGetValue<String>('first', control);

  finally
    jsonObj.Free;
  end;

  try
    if (script = 'right click') then
      RightClick(AOwner, control)
    else if (script = 'left click') then
      LeftClick(AOwner, control)
    else if (script = 'double click') then
      DoubleClick(AOwner, control)
    else
      Error(404);

  except on e: Exception do
    Error(404);
  end;
end;

procedure TPostExecuteCommand.DoubleClick (AOwner: TForm; Const control: String);
begin

end;

procedure TPostExecuteCommand.LeftClick (AOwner: TForm; Const control: String);
begin

end;

procedure TPostExecuteCommand.RightClick (AOwner: TForm; Const control: String);
var
  gridTop, top: Integer;
  gridLeft, left: Integer;
  parent, comp: TComponent;
  values : TStringList;
  value: String;
  parentGrid: TStringGrid;

const
  Delimiter = '.';

begin
  // find the control / component - currently only implemented for stringgrids

    if (ContainsText(control, Delimiter)) then
    begin
      values := TStringList.Create;
      try
        values.Delimiter := Delimiter;
        values.StrictDelimiter := True;
        values.DelimitedText := control;

        // Get parent
        parent := AOwner.FindComponent(values[0]);

        if (parent is TStringGrid) then
        begin
          parentGrid := (parent as TStringGrid);
          gridTop := parentGrid.top;
          gridLeft := parentGrid.left;

          left := parentGrid.CellRect(StrToInt(values[1]),StrToInt(values[2])).left -gridLeft +1;
          top := parentGrid.CellRect(StrToInt(values[1]),StrToInt(values[2])).top -gridTop +1;

          // Cell 2,2 : left = 179, top = 85 ???
          // Here we have to call into the grid itself somehow

          ResponseJSON(OKResponse(self.Params[2], control));
        end
        else
          Error(404);
      finally
        values.free;
      end;
    end
    else
    begin
      comp := AOwner.FindComponent(control);

      if comp <> nil then
      begin
        if (comp is TToolButton) then
        begin
          if (comp as TToolButton).PopupMenu <> nil then
          begin
            // Popup a menu item here
            (comp as TToolButton).PopupMenu.Popup(100, 100);
            ResponseJSON(OKResponse(self.Params[2], control));
          end
          else
          begin
            Error(404);
          end;
        end;
      end
      else
        Error(404);
    end;
end;

function TPostExecuteCommand.OKResponse(const sessionId, control: String): String;
var
  jsonObject: TJSONObject;

begin
  jsonObject := TJSONObject.Create;

  jsonObject.AddPair(TJSONPair.Create('sessionID', sessionId));
  jsonObject.AddPair(TJSONPair.Create('status', '0'));
  jsonObject.AddPair(TJSONPair.Create('value', control));

  result := jsonObject.ToString;
end;

class function TPostExecuteCommand.GetCommand: String;
begin
  result := 'POST';
end;

class function TPostExecuteCommand.GetRoute: String;
begin
  result := '/session/(.*)/execute';
end;

end.
