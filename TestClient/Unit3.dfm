object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 421
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    744
    421)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 728
    Height = 341
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object btnStartSession: TButton
    Left = 8
    Top = 355
    Width = 75
    Height = 25
    Caption = 'Start Session'
    TabOrder = 1
    OnClick = btnStartSessionClick
  end
  object Button1: TButton
    Left = 8
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Status'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 89
    Top = 355
    Width = 75
    Height = 25
    Caption = 'Timeout'
    TabOrder = 3
    OnClick = Button2Click
  end
  object StaticText1: TStaticText
    Left = 176
    Top = 355
    Width = 451
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    TabOrder = 4
  end
  object Button3: TButton
    Left = 89
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Async'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 170
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Get Element'
    TabOrder = 6
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 251
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Get Session'
    TabOrder = 7
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 332
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Get Sessions'
    TabOrder = 8
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 413
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Delete Session'
    TabOrder = 9
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 544
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Error'
    TabOrder = 10
    OnClick = Button8Click
  end
end