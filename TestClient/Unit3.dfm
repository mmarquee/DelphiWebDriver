object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 639
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
    639)
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
    OnClick = DeleteClick
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
  object Button9: TButton
    Left = 8
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Click OK'
    TabOrder = 11
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 8
    Top = 487
    Width = 75
    Height = 25
    Caption = 'Click Cancel'
    TabOrder = 12
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 89
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Click Error'
    TabOrder = 13
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 170
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Title'
    TabOrder = 14
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 170
    Top = 487
    Width = 75
    Height = 25
    Caption = 'Text'
    TabOrder = 15
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 413
    Top = 417
    Width = 75
    Height = 25
    Caption = 'Delete Invalid'
    TabOrder = 16
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 251
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Get Window'
    TabOrder = 17
    OnClick = Button15Click
  end
  object Button16: TButton
    Left = 170
    Top = 518
    Width = 75
    Height = 25
    Caption = 'Get Elemnt'
    TabOrder = 18
    OnClick = Button16Click
  end
  object Button17: TButton
    Left = 251
    Top = 518
    Width = 118
    Height = 25
    Caption = 'Get Elemnt By Text'
    TabOrder = 19
    OnClick = Button17Click
  end
  object Button18: TButton
    Left = 380
    Top = 518
    Width = 118
    Height = 25
    Caption = 'Get Elemnt By Name'
    TabOrder = 20
    OnClick = Button18Click
  end
  object Button19: TButton
    Left = 544
    Top = 430
    Width = 153
    Height = 25
    Caption = 'Elements By ClassName'
    TabOrder = 21
    OnClick = Button19Click
  end
  object Button20: TButton
    Left = 380
    Top = 549
    Width = 149
    Height = 25
    Caption = 'Get/Click Elemnt By Name'
    TabOrder = 22
    OnClick = Button20Click
  end
  object Button21: TButton
    Left = 544
    Top = 549
    Width = 153
    Height = 25
    Caption = 'Speedbuttons By ClassName'
    TabOrder = 23
    OnClick = Button21Click
  end
  object Button22: TButton
    Left = 544
    Top = 488
    Width = 153
    Height = 25
    Caption = 'Click Speedbutton'
    TabOrder = 24
    OnClick = Button22Click
  end
  object Button23: TButton
    Left = 128
    Top = 560
    Width = 117
    Height = 25
    Caption = 'Get Grid Items'
    TabOrder = 25
    OnClick = Button23Click
  end
  object Button24: TButton
    Left = 128
    Top = 591
    Width = 117
    Height = 25
    Caption = 'Get List Items'
    TabOrder = 26
    OnClick = Button24Click
  end
  object Button25: TButton
    Left = 251
    Top = 580
    Width = 117
    Height = 25
    Caption = 'Get List Item Text'
    TabOrder = 27
    OnClick = Button25Click
  end
  object Button26: TButton
    Left = 374
    Top = 580
    Width = 149
    Height = 25
    Caption = 'Get Grid Item Text'
    TabOrder = 28
    OnClick = Button26Click
  end
  object ComboBox1: TComboBox
    Left = 544
    Top = 461
    Width = 153
    Height = 21
    Style = csDropDownList
    TabOrder = 29
    Items.Strings = (
      'TButton'
      'TEdit'
      'TSpeedButton'
      'TTabSheet'
      'TAutomationStringGrid'
      'TListBox'
      'TComboBox'
      'TAutomatedCombobox'
      'TAutomatedEdit'
      'TRadioButton'
      'TPageControl'
      'TCheckBox'
      'TToolbar'
      'TToolButton')
  end
  object ComboBox2: TComboBox
    Left = 544
    Top = 522
    Width = 153
    Height = 21
    Style = csDropDownList
    TabOrder = 30
    Items.Strings = (
      '1'
      '2'
      '3')
  end
  object Button27: TButton
    Left = 544
    Top = 580
    Width = 149
    Height = 25
    Caption = 'Get TabItem Text'
    TabOrder = 31
    OnClick = Button27Click
  end
  object Button28: TButton
    Left = 374
    Top = 606
    Width = 149
    Height = 25
    Caption = 'Right-Click on Grid'
    TabOrder = 32
    OnClick = Button28Click
  end
  object ComboBox3: TComboBox
    Left = 544
    Top = 610
    Width = 153
    Height = 21
    Style = csDropDownList
    TabOrder = 33
    Items.Strings = (
      '0'
      '1'
      '2')
  end
end
