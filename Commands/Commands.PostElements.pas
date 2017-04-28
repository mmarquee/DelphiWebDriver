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
unit Commands.PostElements;

interface

uses
  generics.collections,
  Vcl.Forms,
  Vcl.controls,
  System.Classes,
  CommandRegistry,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'POST' '/session/(.*)/elements'
  ///  </summary>
  TPostElementsCommand = class(TRestCommand)
  private
    procedure GetElementsByName(const value:String; AOwner: TForm);
    procedure GetElementsByCaption(const value:String; AOwner: TForm);
    procedure GetElementsByPartialCaption(const value:String; AOwner: TForm);
    procedure GetElementsByClassName(const value:String; AOwner: TForm);

    function OKResponse(const sessionId: String; elements: TObjectList<TComponent>): String;
  public
    class function GetCommand: String; override;
    class function GetRoute: String; override;

    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.JSON,
  Vcl.stdctrls,
  System.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders;

procedure TPostElementsCommand.GetElementsByName(const value:String; AOwner: TForm);
var
  comps: TObjectList<TComponent>;
  i: Integer;

begin
  comps:= TObjectList<TComponent>.create;

  try
    try
      if (AOwner.Name = value) then
        comps.Add(AOwner)
      else
      begin
        for i := 0 to tForm(AOwner).ControlCount -1 do
        begin
          if tForm(AOwner).Controls[i].Name = value then
          begin
            comps.Add(AOwner.Controls[i]);
          end;
        end;
      end;

      if comps.count = 0 then
        raise Exception.Create('Control(s) not found');

      ResponseJSON(self.OKResponse(self.Params[1], comps));

    except on e: Exception do
      // Probably should give a different reply

      Error(401);
    end;
  finally
//    comps.free;
  end;
end;

procedure TPostElementsCommand.GetElementsByPartialCaption(const value:String; AOwner: TForm);
begin

end;

procedure TPostElementsCommand.GetElementsByCaption(const value:String; AOwner: TForm);
begin

end;

procedure TPostElementsCommand.GetElementsByClassName(const value:String; AOwner: TForm);
var
  comps: TObjectList<TComponent>;
  i: Integer;

begin
  comps:= TObjectList<TComponent>.create;

  try
    try
      if (AOwner.ClassName = value) then
        comps.Add(AOwner)
      else
      begin
        for i := 0 to tForm(AOwner).ComponentCount -1 do
        begin
          if tForm(AOwner).Components[i].ClassName = value then
          begin
            comps.Add(AOwner.Components[i]);
          end;
        end;
      end;

      if comps.count = 0 then
        raise Exception.Create('Control(s) not found');

      ResponseJSON(self.OKResponse(self.Params[1], comps));

    except on e: Exception do
      // Probably should give a different reply
      Error(404);
    end;
  finally
//    comps.free;
  end;
end;

procedure TPostElementsCommand.Execute(AOwner: TForm);
var
  jsonObj : TJSONObject;
  using: String;
  value: String;

begin
  // Decode request
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('using', using);
    (jsonObj as TJsonObject).TryGetValue<String>('value', value);
  finally
    jsonObj.Free;
  end;

  if (using = 'link text') then
    GetElementsByCaption(value, AOwner)
  else if (using = 'name') then
    GetElementsByName(value, AOwner)
  else if (using = 'class name') then
    GetElementsByClassName(value, AOwner)
  else if (using = 'partial link text') then
    GetElementsByPartialCaption(value, AOwner)
end;

function TPostElementsCommand.OKResponse(const sessionId: String; elements: TObjectList<TComponent>): String;
var
  i: Integer;
  jsonPair: TJSONPair;
  jsonObject, arrayObject: TJSONObject;
  jsonArray: TJSONArray;

begin
  jsonArray := TJSONArray.Create;
  jsonObject := TJSONObject.Create;
  jsonPair := TJSONPair.Create('value', jsonArray);

  jsonObject.AddPair(TJSONPair.Create('sessionID', sessionId));
  jsonObject.AddPair(TJSONPair.Create('status', '0'));

  for i := 0 to elements.count -1 do
  begin
    arrayObject := TJSONObject.Create;

    if (elements[i] is TWinControl) then
      // Great we can use the actual window handle
      arrayObject.AddPair(TJSONPair.Create('ELEMENT', IntToStr((elements[i] as TWinControl).Handle)))
    else
      // Use the name, as it won't have a true handle
      arrayObject.AddPair(TJSONPair.Create('ELEMENT', elements[i].name));

    jsonArray.AddElement(arrayObject);
  end;

  jsonObject.AddPair(jsonPair);

  result := jsonObject.ToString;
end;

class function TPostElementsCommand.GetCommand: String;
begin
  result := 'POST';
end;

class function TPostElementsCommand.GetRoute: String;
begin
  result := '/session/(.*)/elements';
end;

end.
