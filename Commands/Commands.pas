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
unit Commands;

interface

uses
  Sessions,
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TUnimplementedCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

type
  ///  <summary>
  ///  Handles 'GET' '/status'
  ///  </summary>
  TStatusCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

type
  TGetSessionsCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

type
  TGetSessionCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

type
  TGetTitleCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

type
  TSessionTimeoutsCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

type
  TPostImplicitWaitCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

type
  TGetElementCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

type
  TGetWindowCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

var
  Sessions: TSessions;

implementation

uses
  windows,
  Vcl.stdctrls,
  System.Classes,
  System.SysUtils,
  vcl.controls,
  System.JSON,
  System.Types,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  Utils,
  Session;

procedure TStatusCommand.Execute(AOwner: TForm);
begin
  try
    ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
  except on e: Exception do
    Error(404);
  end;
end;

class function TStatusCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TStatusCommand.GetRoute: String;
begin
  result := '/status';
end;

procedure TSessionTimeoutsCommand.Execute(AOwner: TForm);
var
  jsonObj : TJSONObject;
  requestType: String;
  value: String;

begin
  // Set timeout for the session

  // Decode the incoming JSON and see what we have
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('type', requestType);
    (jsonObj as TJsonObject).TryGetValue<String>('ms', value);
  finally
    jsonObj.Free;
  end;

  ResponseJSON(Sessions.SetSessionTimeouts(self.Params[1], StrToInt(value)));
end;

procedure TPostImplicitWaitCommand.Execute(AOwner: TForm);
var
  jsonObj : TJSONObject;
  requestType: String;
  value: String;

begin
  // Set timeout for the session

  // Decode the incoming JSON and see what we have
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('type', requestType);
    (jsonObj as TJsonObject).TryGetValue<String>('ms', value);
  finally
    jsonObj.Free;
  end;

  ResponseJSON(Sessions.SetSessionImplicitTimeouts(self.Params[1], StrToInt(value)));
end;

procedure TGetElementCommand.Execute(AOwner: TForm);
begin
  ResponseJSON('{''TGetElementCommand'':'''+ self.Params[1] + '''}');
end;

procedure TGetSessionCommand.Execute(AOwner: TForm);
begin
  try
    ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
  except on e: Exception do
    Error(404);
  end;
end;

procedure TGetSessionsCommand.Execute(AOwner: TForm);
begin
  // No longer correct, needs to be a json array
  ResponseJSON(Sessions.GetSessionStatus(self.Params[1]));
end;

class function TGetSessionsCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetSessionsCommand.GetRoute: String;
begin
  result := '/sessions';
end;

class function TGetSessionCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetSessionCommand.GetRoute: String;
begin
  result := '/session/(.*)';
end;

class function TGetElementCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetElementCommand.GetRoute: String;
begin
  result := '/session/(.*)/element';
end;


procedure TUnimplementedCommand.Execute(AOwner: TForm);
begin
  Error(501);
end;

procedure TGetTitleCommand.Execute(AOwner: TForm);
var
  caption : String;
begin
  // Here we are assuming it is a form
  caption := AOwner.Caption;     // Never gets a caption for some reason
  ResponseJSON(caption);
end;

class function TGetTitleCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetTitleCommand.GetRoute: String;
begin
  result := '/session/(.*)/title';
end;

procedure TGetWindowCommand.Execute(AOwner: TForm);
var
  handle : HWND;
begin
  try
    handle := AOwner.Handle;
    ResponseJSON(intToStr(handle));
  except on e: Exception do
    Sessions.ErrorResponse ('7', 'no such element', 'An element could not be located on the page using the given search parameteres');
  end;
end;

class function TSessionTimeoutsCommand.GetCommand: String;
begin
  result := 'POST';
end;

class function TSessionTimeoutsCommand.GetRoute: String;
begin
  result := '/session/(.*)/timeouts';
end;

class function TPostImplicitWaitCommand.GetCommand: String;
begin
  result := 'POST';
end;

class function TPostImplicitWaitCommand.GetRoute: String;
begin
  result := '/session/(.*)/timeouts/implicit_wait';
end;

class function TGetWindowCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetWindowCommand.GetRoute: String;
begin
  result := '/session/(.*)/window';
end;

initialization
  Sessions := TSessions.Create;

finalization
  Sessions.Free;

end.
