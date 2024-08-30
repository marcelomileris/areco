unit uProdutos;

interface

uses
  uFunctions, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.JSON,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmProdutos = class(TForm)
    Label1: TLabel;
    editID: TEdit;
    Label2: TLabel;
    editNome: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    editPreco: TEdit;
    Label5: TLabel;
    editQtde: TEdit;
    Label6: TLabel;
    editUnidade: TEdit;
    Label7: TLabel;
    editSKU: TEdit;
    Label8: TLabel;
    editCodBarras: TEdit;
    Label9: TLabel;
    editCategoria: TEdit;
    Label10: TLabel;
    editMarca: TEdit;
    editDescricao: TMemo;
    pnlBottom: TPanel;
    btnSair: TSpeedButton;
    btnSalvar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSalvarClick(Sender: TObject);
    procedure editDescricaoKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ClearFields;
    procedure Save;
    { Private declarations }
  public
    loID: String;
    { Public declarations }
  end;

var
  frmProdutos: TfrmProdutos;

implementation

{$R *.dfm}

// Limpa os campos, seta o valor do ID se houver
procedure TfrmProdutos.btnSalvarClick(Sender: TObject);
begin
  Save;
end;

procedure TfrmProdutos.ClearFields();
var
  i: integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
      TEdit(Components[i]).Clear;
    if Components[i] is TMemo then
      TMemo(Components[i]).Clear;
  end;
  editID.Text := loID;
  editNome.SetFocus;
end;

procedure TfrmProdutos.editDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
  Key := AnsiUpperCase(Key)[1];
end;

procedure TfrmProdutos.Save();
var
  JSON, Res: TJSONObject;
  x: TJSONObject;
  JSONSuccess, JSONMsg: String;
begin
  JSON := TJSONObject.Create;
  with JSON do
  begin
    AddPair('name', editNome.Text);
    AddPair('description', editDescricao.Text);
    AddPair('price', editPreco.Text);
    AddPair('quantity', editQtde.Text);
    AddPair('unitmeasure', editUnidade.Text);
    AddPair('sku', editSKU.Text);
    AddPair('barcode', editCodBarras.Text);
    AddPair('category', editCategoria.Text);
    AddPair('brand', editMarca.Text);
  end;
  if (loID = '') then
    Res := API.doReq('POST', '/add', JSON.ToString)
  else
    Res := API.doReq('PUT', '/update/' + loID, JSON.ToString);

  JSONSuccess := Res.GetValue('success').ToString;

  JSONMsg := Res.GetValue<string>('message');

  if (JSONSuccess = 'false') then
    MessageDlg(JSONMsg, mtError, [mbOk], 0)
  else
  begin
    MessageDlg(JSONMsg, mtInformation, [mbOk], 0);
    Close;
  end;

end;

{ * ************************************************* * }
procedure TfrmProdutos.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProdutos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Close;
    VK_INSERT:
      Save;
  end;
end;

procedure TfrmProdutos.FormShow(Sender: TObject);
begin

  if (loID = '') then
  begin
    btnSalvar.Caption := 'Adicionar [F5]';
    ClearFields;
  end
  else
    btnSalvar.Caption := 'Alterar [F5]';
end;

end.
