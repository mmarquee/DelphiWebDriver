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
  AutomatedCombobox in '..\..\DelphiUIAutomation\controls\AutomatedCombobox.pas',
  AutomatedEdit in '..\..\DelphiUIAutomation\controls\AutomatedEdit.pas',
  AutomatedMaskEdit in '..\..\DelphiUIAutomation\controls\AutomatedMaskEdit.pas',
  AutomatedStaticText in '..\..\DelphiUIAutomation\controls\AutomatedStaticText.pas',
  AutomatedStringGrid in '..\..\DelphiUIAutomation\controls\AutomatedStringGrid.pas',
  DemoForm in '..\..\DelphiUIAutomation\controls\DemoForm.pas' {Form2},
  StringGridItem in '..\..\DelphiUIAutomation\controls\StringGridItem.pas',
  UIAutomationCore_TLB in '..\..\DelphiUIAutomation\controls\UIAutomationCore_TLB.pas',
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
  Commands.PostExecute in '..\Commands\Commands.PostExecute.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
