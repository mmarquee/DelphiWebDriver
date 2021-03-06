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
unit Commands.PostElement;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'POST' '/session/(.*)/element'
  ///  </summary>
  TPostElementCommand = class(TRestCommand)
  private
    procedure GetElementByName(const value:String; AOwner: TForm);
    procedure GetElementByCaption(const value:String; AOwner: TForm);
    procedure GetElementByClassName(const value:String; AOwner: TForm);
    procedure GetElementByPartialCaption(const value:String; AOwner: TForm);

    function OKResponse(const sessionId, handle: String): String;
  public
    class function GetCommand: String; override;
    class function GetRoute: String; override;

    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.JSON,
  Vcl.controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Types,
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders;

procedure TPostElementCommand.GetElementByName(const value:String; AOwner: TForm);
var
  comp: TComponent;

begin
  try
    if (AOwner.Caption = value) then
      comp := AOwner
    else
      comp := AOwner.FindComponent(value);

    if comp = nil then
      raise Exception.Create('Control not found');

    if (comp is TWinControl) then
      ResponseJSON(self.OKResponse(self.Params[1], IntToStr((comp as TWinControl).Handle)))
    else
      ResponseJSON(self.OKResponse(self.Params[1], comp.name));

  except on e: Exception do
    // Probably should give a different reply
    Error(404);
  end;
end;

procedure TPostElementCommand.GetElementByClassName(const value:String; AOwner: TForm);
var
  comp: TComponent;
  i: Integer;

begin
  comp := nil;

  try
    if (AOwner.ClassName = value) then
      comp := AOwner
    else
    begin
      for i := 0 to tForm(AOwner).ControlCount -1 do
        if tForm(AOwner).Controls[i].ClassName = value then
        begin
          comp := tForm(AOwner).Controls[i];
          break;
        end;
    end;

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(self.OKResponse(self.Params[1], IntToStr((comp as TWinControl).Handle)));

  except on e: Exception do
    // Probably should give a different reply
    Error(404);
  end;
end;

procedure TPostElementCommand.GetElementByPartialCaption(const value:String; AOwner: TForm);
begin
  Error(404);
end;

procedure TPostElementCommand.GetElementByCaption(const value:String; AOwner: TForm);
var
  comp: TComponent;
  i: Integer;

begin
  comp := nil;

  try
    if (AOwner.Caption = value) then
      comp := AOwner
    else
    begin
      for i := 0 to tForm(AOwner).ControlCount -1 do

        // Vcl.ExtCtrls ..
        // TButtonedEdit
        // THeader
        // TPanel

        // Vcl.StdCtrls ..
        // TButton - done
        // TCheckBox
        // TComboBox
        // TEdit
        // TLabel
        // TListBox
        // TRadioButton
        // TStaticText
        // TMemo

        // Specifically from the test host
        // TTreeView
        // TRichEdit
        // TToolbar
        // TToolbarButton
        // TPageControl
        // TTabSheet
        // TStatusBar
        // TMainMenu
        // TMenuItem
        // TPopupMenu
        // TStringGrid
        // TMaskedEdit
        // TLinkLabel

        // TSpeedButton - no window here, need to 'fake' one

        // Need to get each type of control and check the caption / text
        if (tForm(AOwner).Controls[i] is TButton) then
        begin
          if (tForm(AOwner).Controls[i] as TButton).caption = value then
          begin
            comp := tForm(AOwner).Controls[i];
            break;
          end;
        end
        else if (tForm(AOwner).Controls[i] is TPanel) then
        begin
          if (tForm(AOwner).Controls[i] as TPanel).caption = value then
          begin
            comp := tForm(AOwner).Controls[i];
            break;
          end;
        end
        else if (tForm(AOwner).Controls[i] is TEdit) then
        begin
          if (tForm(AOwner).Controls[i] as TEdit).Text = value then
          begin
            comp := tForm(AOwner).Controls[i];
            break;
          end;
        end;
    end;

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(self.OKResponse(self.Params[1], IntToStr((comp as TWinControl).Handle)));

  except on e: Exception do
    // Probably should give a different reply
    Error(404);
  end;
end;

procedure TPostElementCommand.Execute(AOwner: TForm);
var
  jsonObj : TJSONObject;
  using: String;
  value: String;

begin
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('using', using);
    (jsonObj as TJsonObject).TryGetValue<String>('value', value);
  finally
    jsonObj.Free;
  end;

  if (using = 'link text') then
    GetElementByCaption(value, AOwner)
  else if (using = 'name') then
    GetElementByName(value, AOwner)
  else if (using = 'class name') then
    GetElementByClassName(value, AOwner)
  else if (using = 'partial link text') then
    GetElementByPartialCaption(value, AOwner)
  else
    Error(404);
  // 'id' (automation id)
end;

function TPostElementCommand.OKResponse(const sessionId, handle: String): String;
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
      .BeginObject('value')
        .Add('ELEMENT', Handle)
      .EndObject
    .EndObject;

  result := StringBuilder.ToString;

end;

class function TPostElementCommand.GetCommand: String;
begin
  result := 'POST';
end;

class function TPostElementCommand.GetRoute: String;
begin
  result := '/session/(.*)/element';
end;

end.
