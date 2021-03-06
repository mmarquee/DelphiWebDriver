{***************************************************************************}
{                                                                           }
{           DelphiUIAutomation                                              }
{                                                                           }
{           Copyright 2015-16 JHC Systems Limited                              }
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
program TestHost;

uses
  Vcl.Forms,
  HostMain in 'HostMain.pas' {Form1},
  CommandRegistry in '..\CommandRegistry.pas',
  HttpServerCommand in '..\HttpServerCommand.pas',
  JsonAttributeSource in '..\JsonAttributeSource.pas',
  ResourceProcessing in '..\ResourceProcessing.pas',
  RestServer in '..\RestServer.pas',
  Session in '..\Session.pas',
  Sessions in '..\Sessions.pas',
  Utils in '..\Utils.pas',
  Commands.ClickElement in '..\Commands\Commands.ClickElement.pas',
  Commands.CreateSession in '..\Commands\Commands.CreateSession.pas',
  Commands.GetRect in '..\Commands\Commands.GetRect.pas',
  Commands.GetText in '..\Commands\Commands.GetText.pas',
  Commands in '..\Commands\Commands.pas',
  Commands.PostElement in '..\Commands\Commands.PostElement.pas',
  Commands.PostElementElements in '..\Commands\Commands.PostElementElements.pas',
  Commands.PostElements in '..\Commands\Commands.PostElements.pas',
  Commands.PostExecute in '..\Commands\Commands.PostExecute.pas',
  Commands.GetEnabled in '..\Commands\Commands.GetEnabled.pas',
  Commands.PostValue in '..\Commands\Commands.PostValue.pas',
  Commands.DeleteSession in '..\Commands\Commands.DeleteSession.pas',
  Commands.GetWindowHandle in '..\Commands\Commands.GetWindowHandle.pas',
  Commands.PostClear in '..\Commands\Commands.PostClear.pas',
  Commands.GetElementValue in '..\Commands\Commands.GetElementValue.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
