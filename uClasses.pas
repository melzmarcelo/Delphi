unit uClasses;

interface

type
  TCarros = class
  private
    FCodigo: Integer;
    FModelo: string;
    FDataLancamento: TDateTime;
    procedure SetCodigo(const Value: Integer);
    procedure SetModelo(const Value: string);
    procedure SetDataLancamento(const Value: TDateTime);

  published
    property Codigo  : Integer read FCodigo write SetCodigo;
    property Modelo  : string read FModelo write SetModelo;
    property DataLancamento : TDateTime read FDataLancamento write SetDataLancamento;

    class function Inserir(pModelo: string; pDataLancamento:TDateTime): TCarros;
    class function Buscar(pCodigo: Integer):TCarros;
  end;

  TCliente = class
  private
    FCodigo: Integer;
    FCPF: String;
    procedure SetCodigo(const Value: Integer);
    procedure SetCPF(const Value: String);
  published
    property Codigo : Integer read FCodigo write SetCodigo;
    property CPF : String read FCPF write SetCPF;

    class function Inserir(pCPF: string): TCliente;
    class function Buscar(pCodigo: Integer):TCliente;
  end;

  TVendas = class
  private
    FCodigo: Integer;
    FCliente: TCliente;
    FCarro: TCarros;
    procedure SetCodigo(const Value: Integer);
    procedure SetCliente(const Value: TCliente);
    procedure SetCarro(const Value: TCarros);

  published
    property Codigo : Integer read FCodigo write SetCodigo;
    property Cliente : TCliente read FCliente write SetCliente;
    property Carro : TCarros read FCarro write SetCarro;

    class function Inserir(pCliente: TCliente; pCarros: TCarros):TVendas;
  end;

  TRotina = class
  public
    procedure Executar;
  end;

implementation

uses uClasses;

{ Carros }

class function TCarros.Buscar(pCodigo: Integer): TCarros;
begin
  Result := TCarros.Create;
  //Utilizei o ExecutarSql para retornar campo a campo
  Result.Codigo := pCodigo;
  Result.Modelo := ExecutarSql('Select Modelo from Carros where codigo = ' + IntToStr(pCodigo));
  Result.DataLancamento := ExecutarSql('Select DataLancamento from Carros where codigo = ' + IntToStr(pCodigo));
end;

class function TCarros.Inserir(pModelo: string; pDataLancamento:TDateTime): TCarros;
begin
  Result := TCarros.Create;
  Result.Codigo := ExecutarSql('Select max(cod) + 1 as Codigo from Carros ');
  Result.Modelo := pModelo;
  Result.DataLancamento := pDataLancamento;
  InserirDadosBD('insert into Carros (Codigo, Modelo, DataLancamento) values ('+IntToStr(Result.Codigo)+','+Result.Modelo+','+DateTimeToStr(pDataLancamento)+')');
end;

procedure TCarros.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TCarros.SetDataLancamento(const Value: TDateTime);
begin
  FDataLancamento := Value;
end;

procedure TCarros.SetModelo(const Value: string);
begin
  FModelo := Value;
end;

{ Cliente }

class function TCliente.Buscar(pCodigo: Integer): TCliente;
begin
  Result := TCliente.Create;
  //Utilizei o ExecutarSql para retornar campo a campo
  Result.Codigo := pCodigo;
  Result.CPF := ExecutarSql('Select CPF from Cliente where codigo = ' + IntToStr(pCodigo));
end;

class function TCliente.Inserir(pCPF: string): TCliente;
begin
  if ExecutarSql('Select count(1) as CPF from Cliente where CPF = '''+pCPF+'''') = 0 then
  begin
    Result := TCliente.Create;
    Result.Codigo := ExecutarSql('Select max(cod) + 1 as Codigo from Cliente ');
    Result.CPF   := pCPF;
    InserirDadosBD('insert into Cliente (Codigo, CPF) values ('+IntToStr(Result.Codigo)+','+Result.CPF+')');
  end;
end;

procedure TCliente.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TCliente.SetCPF(const Value: String);
begin
  FCPF := Value;
end;

{ Vendas }

class function TVendas.Inserir(pCliente: TCliente;
  pCarros: TCarros): TVendas;
begin
  Result := TVendas.Create;
  Result.Codigo := ExecutarSql('Select max(cod) + 1 as Codigo from Vendas ');
  Result.Cliente := pCliente;
  Result.Carros  := pCarros;
  InserirDadosBD('insert into Carros (Codigo, Modelo, DataLancamento) values ('+IntToStr(Result.Codigo)+','+Result.Modelo+','+DateTimeToStr(pDataLancamento)+')');v
end;

procedure TVendas.SetCarro(const Value: TCarros);
begin
  FCarro := Value;
end;

procedure TVendas.SetCliente(const Value: TCliente);
begin
  FCliente := Value;
end;

procedure TVendas.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

{ TRotina }

procedure TRotina.Executar;
begin
  TCliente.Inserir('000.000.000-00');
  TCliente.Inserir('111.111.111-11');
  TCliente.Inserir('222.222.222-22');
  TCliente.Inserir('333.333.333-33');
  TCliente.Inserir('444.444.444-44');

  TCarros.Inserir('Marea', Now);
  TCarros.Inserir('Uno', Now);
  TCarros.Inserir('Palio', Now);
  TCarros.Inserir('Gol', Now);
  TCarros.Inserir('Vectra', Now);
end;

end.
 