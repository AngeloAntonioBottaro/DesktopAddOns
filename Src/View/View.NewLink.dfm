object ViewNewLink: TViewNewLink
  Left = 0
  Top = 0
  Caption = 'Links'
  ClientHeight = 299
  ClientWidth = 626
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 626
    Height = 258
    Align = alClient
    Columns = <
      item
        Caption = 'Link'
        Width = 600
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu
    TabOrder = 0
    ViewStyle = vsReport
  end
  object pn: TPanel
    Left = 0
    Top = 258
    Width = 626
    Height = 41
    Align = alBottom
    TabOrder = 1
    object edtLink: TEdit
      Left = 8
      Top = 6
      Width = 377
      Height = 21
      TabOrder = 0
      Text = 'edtLink'
    end
    object btnAddLink: TButton
      Left = 391
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Adicionar'
      TabOrder = 1
      OnClick = btnAddLinkClick
    end
  end
  object PopupMenu: TPopupMenu
    Left = 216
    Top = 64
    object Deletarlink1: TMenuItem
      Caption = 'Deletar link'
      OnClick = Deletarlink1Click
    end
  end
end
