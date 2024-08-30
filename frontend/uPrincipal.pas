unit uPrincipal;

interface

uses
  uProdutos, uFunctions, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client, Vcl.StdCtrls,
  Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, MidasLib, System.JSON,
  System.ImageList, Vcl.ImgList;

type
  TfrmPrincipal = class(TForm)
    pnlBottom: TPanel;
    btnEncerrar: TSpeedButton;
    btnNovoProduto: TSpeedButton;
    cdsProducts: TClientDataSet;
    DBGProducts: TDBGrid;
    dsProducts: TDataSource;
    pnlTop: TPanel;
    editFiltro: TEdit;
    SpeedButton1: TSpeedButton;
    btnRefresh: TSpeedButton;
    btnDelete: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    procedure btnEncerrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNovoProdutoClick(Sender: TObject);
    procedure DBGProductsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGProductsDblClick(Sender: TObject);
    procedure editFiltroKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure FixDBGridColumnsWidth(const Grid: TDBGrid);
const
  DEFBORDER = 10;
var
  temp, n: Integer;
  lmax: array [0 .. 30] of Integer;
begin
  with Grid do
  begin
    DataSource.DataSet.DisableControls;
    Canvas.Font := Font;
    for n := 0 to Columns.Count - 1 do
      // if columns[n].visible then
      lmax[n] := Canvas.TextWidth(Fields[n].FieldName) + DEFBORDER;
    Grid.DataSource.DataSet.First;
    while not Grid.DataSource.DataSet.EOF do
    begin
      for n := 0 to Columns.Count - 1 do
      begin
        // if columns[n].visible then begin
        temp := Canvas.TextWidth(trim(Columns[n].Field.DisplayText)) +
          DEFBORDER;
        if temp > lmax[n] then
          lmax[n] := temp;
        // end; { if }
      end; { for }
      Grid.DataSource.DataSet.Next;
    end; { while }
    Grid.DataSource.DataSet.First;
    for n := 0 to Columns.Count - 1 do
      if lmax[n] > 0 then
        Columns[n].Width := lmax[n];
    DataSource.DataSet.EnableControls;
  end; { With }
end; (* FixDBGridColumnsWidth *)

// Carrega as informações de produtos na lista
procedure LoadInit();
var
  loData: TJSONObject;
  JSON: TJSONArray;

  i: Integer;
  Price: Double;
begin

  // Cria os campos no ClientDataSet
  with frmPrincipal.cdsProducts do
  begin
    FieldDefs.Clear;
    Close;
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('name', ftString, 150);
    FieldDefs.Add('description', ftString, 150);
    FieldDefs.Add('price', ftString, 10);
    FieldDefs.Add('quantity', ftInteger);
    FieldDefs.Add('unitmeasure', ftString, 20);
    FieldDefs.Add('sku', ftString, 20);
    FieldDefs.Add('barcode', ftString, 50);
    FieldDefs.Add('category', ftString, 50);
    FieldDefs.Add('brand', ftString, 50);
    FieldDefs.Add('active', ftBoolean);
    CreateDataSet;
    LogChanges := false;
    Open;
  end;

  // Ajusta as Colunas
  with frmPrincipal.DBGProducts do
  begin
    Columns.Clear;
    Columns[0].Title.Caption := 'ID';
    Columns[0].Title.Alignment := taCenter;
    Columns[0].Alignment := taCenter;
    Columns[1].Title.Caption := 'NOME';
    Columns[2].Title.Caption := 'DESCRIÇÃO';
    Columns[3].Title.Caption := 'PREÇO';
    Columns[3].Title.Alignment := taCenter;
    Columns[3].Alignment := taRightJustify;
    Columns[4].Title.Caption := 'QTDE';
    Columns[4].Title.Alignment := taCenter;
    Columns[4].Alignment := taCenter;
    Columns[5].Title.Caption := 'MEDIDA';
    Columns[5].Title.Alignment := taCenter;
    Columns[5].Alignment := taCenter;
    Columns[6].Title.Caption := 'SKU';
    Columns[6].Title.Alignment := taCenter;
    Columns[6].Alignment := taCenter;
    Columns[7].Title.Caption := 'CÓDIGO BARRAS';
    Columns[7].Title.Alignment := taCenter;
    Columns[7].Alignment := taCenter;
    Columns[8].Title.Caption := 'CATEGORIA';
    Columns[9].Title.Caption := 'MARCA';
    Columns[10].Title.Caption := 'ATIVO';
  end;

  // Realiza a Requisição
  loData := API.doReq('GET', '/list');

  // Faz o Insert no ClientDataSet
  if Assigned(JSON) then
  begin
    try
      JSON := loData.GetValue<TJSONArray>('data');
      with frmPrincipal.cdsProducts do
      begin
        DisableControls;
        for i := 0 to JSON.Count - 1 do
        begin
          loData := JSON.Items[i] as TJSONObject;
          Insert;
          FieldByName('id').AsInteger := loData.GetValue<Integer>('id');
          FieldByName('name').AsString := loData.GetValue<string>('name', '');
          FieldByName('description').AsString :=
            loData.GetValue<string>('description', '');
          FieldByName('description').AsString :=
            loData.GetValue<string>('description', '');
          FieldByName('price').AsString := loData.GetValue<string>('price');
          FieldByName('quantity').AsInteger :=
            loData.GetValue<Integer>('quantity', 0);
          FieldByName('unitmeasure').AsString :=
            loData.GetValue<string>('unitmeasure', '');
          FieldByName('sku').AsString := loData.GetValue<string>('sku', '');
          FieldByName('barcode').AsString :=
            loData.GetValue<string>('barcode', '');
          FieldByName('category').AsString :=
            loData.GetValue<string>('category', '');
          FieldByName('brand').AsString := loData.GetValue<string>('brand', '');
          FieldByName('active').AsBoolean :=
            (loData.GetValue<Integer>('active', 0) = 1);
          Post;
        end;
        First;
        FixDBGridColumnsWidth(frmPrincipal.DBGProducts);
        EnableControls;
      end;
    finally
      JSON.Free;
    end;
  end;

end;

procedure Filter(Filter: String);
var
  like: String;
begin
  like := 'UPPER(name) Like ' + UpperCase(QuotedStr('%' + Filter + '%'));
  with frmPrincipal.cdsProducts do
  begin
    Close;
    Filtered := false;
    Filter := like;
    Filtered := True;
    Open;
  end;
end;

procedure Delete();
var
  JSON, Res: TJSONObject;
  loID: String;
  JSONSuccess, JSONMsg: String;
begin
  if (frmPrincipal.cdsProducts.RecordCount > 0) then
  begin
    loID := frmPrincipal.cdsProducts.FieldByName('id').AsString;
    if MessageDlg('Deseja mesmo excluir o produto?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin

      // Realiza a Requisição
      Res := API.doReq('DELETE', '/delete/' + loID, '');

      JSONSuccess := Res.GetValue('success').ToString;

      JSONMsg := Res.GetValue<string>('message');

      if (JSONSuccess = 'false') then
        MessageDlg(JSONMsg, mtError, [mbOk], 0)
      else
      begin
        MessageDlg(JSONMsg, mtInformation, [mbOk], 0);
        LoadInit;
      end;
    end;

  end;
end;

procedure TfrmPrincipal.btnDeleteClick(Sender: TObject);
begin
  Delete;
end;

procedure TfrmPrincipal.btnEncerrarClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.btnNovoProdutoClick(Sender: TObject);
begin
  try
    frmProdutos := TFrmProdutos.Create(frmPrincipal);
    frmProdutos.ShowModal;
  finally
    frmProdutos.Free;
    LoadInit();
  end;
end;

procedure TfrmPrincipal.btnRefreshClick(Sender: TObject);
begin
  LoadInit;
end;

procedure TfrmPrincipal.DBGProductsDblClick(Sender: TObject);
begin
  try
    if (cdsProducts.RecordCount > 0) then
    begin
      frmProdutos := TFrmProdutos.Create(frmPrincipal);
      frmProdutos.loID := cdsProducts.FieldByName('id').AsString;
      frmProdutos.editID.Text := cdsProducts.FieldByName('id').AsString;
      frmProdutos.editNome.Text := cdsProducts.FieldByName('name').AsString;
      frmProdutos.editDescricao.Text := cdsProducts.FieldByName
        ('description').AsString;
      frmProdutos.editPreco.Text := cdsProducts.FieldByName('price').AsString;
      frmProdutos.editQtde.Text := cdsProducts.FieldByName('quantity').AsString;
      frmProdutos.editSKU.Text := cdsProducts.FieldByName('sku').AsString;
      frmProdutos.editCodBarras.Text := cdsProducts.FieldByName
        ('barcode').AsString;
      frmProdutos.editUnidade.Text := cdsProducts.FieldByName
        ('unitmeasure').AsString;
      frmProdutos.editCategoria.Text := cdsProducts.FieldByName
        ('category').AsString;
      frmProdutos.editMarca.Text := cdsProducts.FieldByName('brand').AsString;
      frmProdutos.ShowModal;
    end;
  finally
    frmProdutos.Free;
    LoadInit();
  end;
end;

procedure TfrmPrincipal.DBGProductsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = 46) then
    Key := 0;
end;

procedure TfrmPrincipal.editFiltroKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Filter(editFiltro.Text);

  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  // Carrega as informações iniciais
  LoadInit();
end;

procedure TfrmPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F5:
      LoadInit;
    VK_INSERT:
      btnNovoProduto.Click;
    VK_DELETE:
      Delete;
  end;
end;

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
  Filter(editFiltro.Text);
end;

end.
