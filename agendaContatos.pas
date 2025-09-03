program AgendaContatos;

uses
  crt, dos;

type
  Contato = record
    nome: string[50];
    telefone: string[20];
    email: string[50];
  end;

const
  arquivoContatos = 'agenda.txt';

procedure Digitar(texto: string; delayTempo: integer);
var
  i: integer;
begin
  for i := 1 to Length(texto) do
  begin
    Write(texto[i]);
    Delay(delayTempo);
  end;
  WriteLn;
end;

procedure AdicionarContato;
var
  f: Text;
  c: Contato;
begin
  ClrScr;
  Digitar('--- Adicionar Novo Contato ---', 15);
  Write('Nome: ');
  ReadLn(c.nome);
  Write('Telefone: ');
  ReadLn(c.telefone);
  Write('E-mail: ');
  ReadLn(c.email);

  Assign(f, arquivoContatos);
  {$I-}
  Append(f);
  if IOResult <> 0 then
    Rewrite(f);
  {$I+}
  WriteLn(f, c.nome);
  WriteLn(f, c.telefone);
  WriteLn(f, c.email);
  WriteLn(f, '---');
  Close(f);

  Digitar('Contato salvo com sucesso!', 15);
  ReadLn;
end;

procedure ListarContatos;
var
  f: Text;
  linha: string;
begin
  ClrScr;
  Digitar('--- Lista de Contatos ---', 15);

  Assign(f, arquivoContatos);
  {$I-}
  Reset(f);
  if IOResult <> 0 then
  begin
    Digitar('Nenhum contato encontrado.', 15);
    ReadLn;
    Exit;
  end;
  {$I+}

  while not Eof(f) do
  begin
    ReadLn(f, linha);
    Digitar(linha, 5);
  end;

  Close(f);
  ReadLn;
end;

procedure BuscarContato;
var
  f: Text;
  linha, nomeBusca: string;
  achou: boolean;
begin
  ClrScr;
  Digitar('--- Buscar Contato por Nome ---', 15);
  Write('Digite o nome a buscar: ');
  ReadLn(nomeBusca);

  Assign(f, arquivoContatos);
  {$I-}
  Reset(f);
  if IOResult <> 0 then
  begin
    Digitar('Nenhum contato encontrado.', 15);
    ReadLn;
    Exit;
  end;
  {$I+}

  achou := False;
  while not Eof(f) do
  begin
    ReadLn(f, linha);
    if Pos(LowerCase(nomeBusca), LowerCase(linha)) > 0 then
    begin
      Digitar('-------------------------------', 5);
      Digitar(linha, 5); // Nome
      ReadLn(f, linha); Digitar(linha, 5); // Telefone
      ReadLn(f, linha); Digitar(linha, 5); // Email
      ReadLn(f, linha); // Separador ---
      achou := True;
    end
    else
    begin
      // Pula as próximas 3 linhas
      ReadLn(f); ReadLn(f); ReadLn(f);
    end;
  end;
  Close(f);

  if not achou then
    Digitar('Contato nao encontrado.', 15);

  ReadLn;
end;

procedure RemoverContato;
var
  f, temp: Text;
  linha, nomeRemover: string;
  nome, telefone, email: string;
  removido: boolean;
begin
  ClrScr;
  Digitar('--- Remover Contato ---', 15);
  Write('Digite o nome do contato a remover: ');
  ReadLn(nomeRemover);

  Assign(f, arquivoContatos);
  Assign(temp, 'temp.txt');

  {$I-}
  Reset(f);
  Rewrite(temp);
  if IOResult <> 0 then
  begin
    Digitar('Erro ao acessar arquivo.', 15);
    ReadLn;
    Exit;
  end;
  {$I+}

  removido := False;
  while not Eof(f) do
  begin
    ReadLn(f, nome);
    ReadLn(f, telefone);
    ReadLn(f, email);
    ReadLn(f, linha); // separador ---

    if LowerCase(nome) <> LowerCase(nomeRemover) then
    begin
      WriteLn(temp, nome);
      WriteLn(temp, telefone);
      WriteLn(temp, email);
      WriteLn(temp, '---');
    end
    else
      removido := True;
  end;
  Close(f);
  Close(temp);

  Erase(f);
  Rename(temp, arquivoContatos);

  if removido then
    Digitar('Contato removido com sucesso.', 15)
  else
    Digitar('Contato nao encontrado.', 15);

  ReadLn;
end;

procedure MostrarMenu;
begin
  ClrScr;
  Digitar('+------------------------------+', 5);
  Digitar('¦     AGENDA DE CONTATOS       ¦', 5);
  Digitar('¦------------------------------¦', 5);
  Digitar('¦ [1] Adicionar Contato        ¦', 5);
  Digitar('¦ [2] Listar Contatos          ¦', 5);
  Digitar('¦ [3] Buscar Contato por Nome  ¦', 5);
  Digitar('¦ [4] Remover Contato          ¦', 5);
  Digitar('¦ [0] Sair                     ¦', 5);
  Digitar('¦                              ¦', 5);
  Digitar('¦ By: Carlos Marques           ¦', 5);
  Digitar('+------------------------------+', 5);
  Write('> ');
end;

var
  opcao: char;

begin
  TextColor(LightGreen);
  TextBackground(Black);
  ClrScr;

  repeat
    MostrarMenu;
    ReadLn(opcao);

    case opcao of
      '1': AdicionarContato;
      '2': ListarContatos;
      '3': BuscarContato;
      '4': RemoverContato;
      '0':
        begin
          Digitar('Saindo...', 30);
          Delay(1000);
        end;
    else
      Digitar('Opcao invalida.', 20);
    end;
  until opcao = '0';
end.

