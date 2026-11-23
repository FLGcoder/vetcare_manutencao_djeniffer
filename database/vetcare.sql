CREATE DATABASE IF NOT EXISTS vetcare_djeniffer CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vetcare;

DROP TABLE IF EXISTS consultas;
DROP TABLE IF EXISTS animais;
DROP TABLE IF EXISTS tutores;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  usuario VARCHAR(50) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL,
  perfil VARCHAR(20) DEFAULT 'admin'
);

INSERT INTO usuarios (nome, usuario, senha, perfil) VALUES
('Administrador VetCare', 'admin', 'admin123', 'admin');

CREATE TABLE tutores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  telefone VARCHAR(30),
  email VARCHAR(120),
  endereco VARCHAR(180),
  ativo TINYINT(1) DEFAULT 1,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE animais (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tutor_id INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  especie VARCHAR(60),
  raca VARCHAR(80),
  nascimento DATE,
  sexo VARCHAR(20),
  observacoes TEXT,
  ativo TINYINT(1) DEFAULT 1,
  CONSTRAINT fk_animal_tutor FOREIGN KEY (tutor_id) REFERENCES tutores(id)
);

CREATE TABLE consultas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  animal_id INT NOT NULL,
  data_consulta DATETIME NOT NULL,
  veterinario VARCHAR(120) NOT NULL,
  motivo VARCHAR(180),
  status VARCHAR(30) DEFAULT 'Agendada',
  observacoes TEXT,
  CONSTRAINT fk_consulta_animal FOREIGN KEY (animal_id) REFERENCES animais(id)
);

INSERT INTO tutores (nome, telefone, email, endereco, ativo) VALUES
('Mariana Costa', '(47) 99999-1001', 'mariana@email.com', 'Centro', 1),
('Rafael Mendes', '(47) 98888-2002', 'rafael@email.com', 'Bairro Cruzeiro', 1),
('Camila Oliveira', '(47) 97777-3003', 'camila@email.com', 'Serra Alta', 1),
('João Pedro Lima', 'abc123', 'joao@email.com', '25 de Julho', 0);

INSERT INTO animais (tutor_id, nome, especie, raca, nascimento, sexo, observacoes, ativo) VALUES
(1, 'Mel', 'Cão', 'Golden Retriever', '2021-05-10', 'Fêmea', 'Alergia alimentar', 1),
(2, 'Mingau', 'Gato', 'SRD', '2023-11-20', 'Macho', 'Vacinação em dia', 1),
(3, 'Thor', 'Cão', 'Labrador', '2025-10-30', 'Macho', '', 1),
(4, 'Pipoca', 'Coelho', 'Mini Lop', '2024-02-15', 'Fêmea', '', 0);

INSERT INTO consultas (animal_id, data_consulta, veterinario, motivo, status, observacoes) VALUES
(1, DATE_ADD(NOW(), INTERVAL 2 DAY), 'Dra. Paula', 'Retorno dermatológico', 'Agendada', ''),
(2, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Dr. André', 'Avaliação de rotina', 'Realizada', ''),
(3, DATE_ADD(NOW(), INTERVAL 5 DAY), 'Dra. Paula', 'Vacinação', 'Agendada', '');


DROP TABLE IF EXISTS historico_chamados;
DROP TABLE IF EXISTS chamados;

CREATE TABLE chamados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(160) NOT NULL,
  modulo VARCHAR(60) NOT NULL,
  solicitante VARCHAR(120) NOT NULL,
  equipe VARCHAR(100),
  descricao TEXT NOT NULL,
  passos TEXT NOT NULL,
  resultado_esperado TEXT NOT NULL,
  resultado_obtido TEXT NOT NULL,
  severidade ENUM('Baixa','Média','Alta','Crítica') NOT NULL DEFAULT 'Média',
  prioridade ENUM('Baixa','Média','Alta','Urgente') NOT NULL DEFAULT 'Média',
  status ENUM('Aberto','Em análise','Aguardando informações','Resolvido','Fechado') NOT NULL DEFAULT 'Aberto',
  responsavel VARCHAR(120),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE historico_chamados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  chamado_id INT NOT NULL,
  autor VARCHAR(120) NOT NULL,
  comentario TEXT NOT NULL,
  status_anterior VARCHAR(40),
  status_novo VARCHAR(40),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_historico_chamado FOREIGN KEY (chamado_id) REFERENCES chamados(id) ON DELETE CASCADE
);

INSERT INTO chamados (
    titulo, modulo, solicitante, equipe, descricao, passos,
    resultado_esperado, resultado_obtido, severidade, prioridade, status
) VALUES


(
    'Exclusão de animal não funciona',
    'Animais',
    'Equipe de testes',
    'Manutenção VetCare',
    'Ao tentar excluir um animal cadastrado, a operação falha devido à ausência da cláusula WHERE na instrução SQL de exclusão, causando erro na execução.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Animais.\n3. Selecione um animal cadastrado.\n4. Clique na opção de excluir.\n5. Confirme a operação, se solicitado.',
    'O animal selecionado deve ser removido do banco de dados.',
    'A exclusão apresenta erro e o animal permanece cadastrado.',
    'Alta',
    'Alta',
    'Aberto'
),


(
    'Cálculo incorreto da idade dos animais',
    'Animais',
    'Equipe de testes',
    'Manutenção VetCare',
    'O cálculo da idade considera apenas o ano de nascimento, ignorando o mês e o dia. Dessa forma, animais que ainda não completaram aniversário podem apresentar idade incorreta.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Animais.\n3. Localize um animal cuja data de nascimento esteja próxima da data atual.\n4. Confira a idade apresentada pelo sistema.',
    'A idade deve considerar o dia e o mês de nascimento, apresentando a idade completa em anos.',
    'A idade é calculada apenas pela diferença entre os anos, podendo apresentar um ano a mais.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Filtro de status das consultas não funciona',
    'Consultas',
    'Equipe de testes',
    'Manutenção VetCare',
    'O filtro de status do módulo Consultas não aplica corretamente o valor selecionado. A variável recebida pelo sistema não está sendo utilizada na consulta SQL.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Consultas.\n3. Utilize o filtro de status.\n4. Selecione Agendada, Realizada ou Cancelada.\n5. Observe os registros exibidos.',
    'O sistema deve apresentar somente as consultas correspondentes ao status selecionado.',
    'A listagem continua apresentando consultas de diferentes status, mesmo após a seleção do filtro.',
    'Alta',
    'Alta',
    'Aberto'
),


(
    'Sistema permite agendamento de consultas em datas passadas',
    'Consultas',
    'Equipe de testes',
    'Manutenção VetCare',
    'O formulário de consultas permite cadastrar agendamentos com datas anteriores à data atual, sem apresentar validação ou bloqueio.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Consultas.\n3. Clique para cadastrar uma nova consulta.\n4. Preencha os campos obrigatórios.\n5. Informe uma data anterior à data atual.\n6. Salve o cadastro.',
    'O sistema deve impedir o cadastro de consultas com datas anteriores à data atual.',
    'O cadastro é aceito mesmo quando a data da consulta está no passado.',
    'Alta',
    'Alta',
    'Aberto'
),


(
    'Exclusão de consulta sem confirmação',
    'Consultas',
    'Equipe de testes',
    'Manutenção VetCare',
    'O sistema permite excluir consultas diretamente, sem exibir uma confirmação de exclusão para o usuário, aumentando o risco de remoção acidental de registros.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Consultas.\n3. Localize uma consulta cadastrada.\n4. Clique na opção de excluir.',
    'O sistema deve solicitar confirmação antes de excluir permanentemente a consulta.',
    'A consulta pode ser excluída sem uma confirmação prévia adequada.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Formulário de consulta perde dados após validação',
    'Consultas',
    'Equipe de testes',
    'Manutenção VetCare',
    'Quando o formulário de consulta apresenta um erro de validação, os dados anteriormente preenchidos não são preservados, obrigando o usuário a preencher novamente os campos.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Consultas.\n3. Inicie o cadastro de uma consulta.\n4. Preencha os campos disponíveis, deixando o veterinário vazio.\n5. Tente salvar o cadastro.\n6. Observe o formulário após a mensagem de erro.',
    'O sistema deve apresentar a mensagem de validação e preservar os dados preenchidos anteriormente.',
    'A mensagem de erro é exibida, porém os dados preenchidos são perdidos.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Dashboard exibe quantidade incorreta de animais',
    'Dashboard',
    'Equipe de testes',
    'Manutenção VetCare',
    'O indicador de animais cadastrados contabiliza todos os registros, incluindo animais inativos. O total exibido não representa corretamente os animais ativos, conforme a regra de negócio RN12.',
    '1. Acesse o sistema VetCare.\n2. Abra o Dashboard.\n3. Verifique o total de animais cadastrados.\n4. Compare o valor com a quantidade de animais ativos no módulo Animais.',
    'O Dashboard deve contabilizar corretamente os animais ativos, conforme a regra de negócio.',
    'O indicador contabiliza animais inativos, apresentando uma quantidade superior à esperada.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Dashboard exibe consultas passadas como próximas',
    'Dashboard',
    'Equipe de testes',
    'Manutenção VetCare',
    'A seção Próximas consultas não filtra os registros pela data atual. Consultas com datas passadas podem ser exibidas como se fossem próximas.',
    '1. Acesse o sistema VetCare.\n2. Abra o Dashboard.\n3. Verifique a seção Próximas consultas.\n4. Observe se existem consultas com datas anteriores à data atual.',
    'A seção deve exibir somente consultas futuras, de acordo com sua finalidade.',
    'Consultas com datas passadas podem aparecer na listagem de próximas consultas.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Contagem de consultas agendadas inclui datas passadas',
    'Dashboard',
    'Equipe de testes',
    'Manutenção VetCare',
    'O indicador de consultas agendadas contabiliza registros com status Agendada sem considerar se a data da consulta já passou.',
    '1. Acesse o sistema VetCare.\n2. Abra o Dashboard.\n3. Verifique o total de consultas agendadas.\n4. Compare o indicador com os registros agendados cuja data ainda não passou.',
    'O indicador deve representar corretamente as consultas que ainda estão efetivamente agendadas para o futuro.',
    'Consultas agendadas com datas passadas também são incluídas no total.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Botão de cadastro de tutor não abre formulário',
    'Tutores',
    'Equipe de testes',
    'Manutenção VetCare',
    'O botão de cadastro de novo tutor possui uma função JavaScript que cancela o comportamento padrão do link, impedindo a navegação para o formulário de cadastro.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Tutores.\n3. Clique no botão Novo Tutor.\n4. Observe o comportamento do sistema.',
    'O botão deve direcionar o usuário para o formulário de cadastro de tutor.',
    'O botão executa uma ação de JavaScript e impede a abertura do formulário de cadastro.',
    'Alta',
    'Alta',
    'Aberto'
),


(
    'Busca de tutores considera somente o primeiro termo',
    'Tutores',
    'Equipe de testes',
    'Manutenção VetCare',
    'A pesquisa de tutores considera apenas a primeira palavra do termo informado, limitando os resultados e prejudicando buscas por nomes completos.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Tutores.\n3. Utilize o campo de pesquisa.\n4. Informe um nome completo de tutor.\n5. Compare os resultados com a pesquisa utilizando somente o primeiro nome.',
    'O sistema deve pesquisar considerando o termo completo informado, permitindo localizar tutores pelo nome completo.',
    'A pesquisa utiliza somente a primeira palavra digitada, ignorando o restante do termo.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Exclusão de tutor sem confirmação',
    'Tutores',
    'Equipe de testes',
    'Manutenção VetCare',
    'O sistema permite executar a exclusão de tutores sem uma confirmação prévia adequada, possibilitando remoções acidentais de registros.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Tutores.\n3. Localize um tutor cadastrado.\n4. Clique na opção de excluir.',
    'O sistema deve solicitar confirmação antes de realizar a exclusão do tutor.',
    'A operação de exclusão pode ser iniciada sem uma confirmação adequada.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Formulário de tutor não preserva dados após erro',
    'Tutores',
    'Equipe de testes',
    'Manutenção VetCare',
    'Ao ocorrer uma falha de validação no cadastro de tutores, os dados previamente preenchidos não são preservados no formulário.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Tutores.\n3. Inicie um novo cadastro.\n4. Preencha alguns campos.\n5. Deixe um campo obrigatório inválido ou vazio.\n6. Tente salvar o cadastro.',
    'O sistema deve informar os campos inválidos e manter os demais dados preenchidos.',
    'Após a validação, os dados preenchidos anteriormente não são mantidos.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Exclusão de tutor não apresenta feedback de erro',
    'Tutores',
    'Equipe de testes',
    'Manutenção VetCare',
    'O tratamento de exceções durante a exclusão de tutores não apresenta informações ao usuário quando ocorre uma falha. A exceção é ignorada e o sistema redireciona sem informar o problema.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Tutores.\n3. Localize um tutor cuja exclusão possa gerar uma restrição no banco de dados.\n4. Tente excluir o registro.\n5. Observe a resposta apresentada pelo sistema.',
    'Caso a exclusão falhe, o sistema deve informar o motivo da falha de forma adequada.',
    'A exceção é ignorada e o usuário não recebe um feedback sobre o erro.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Cadastro de animal apresenta idade incorreta próximo ao aniversário',
    'Animais',
    'Equipe de testes',
    'Manutenção VetCare',
    'O cálculo de idade do animal utiliza apenas o ano de nascimento. Este comportamento pode gerar inconsistências na idade exibida antes do animal completar o aniversário.',
    '1. Acesse o sistema VetCare.\n2. Entre no módulo Animais.\n3. Localize um animal com aniversário ainda não ocorrido no ano atual.\n4. Confira a idade apresentada.',
    'A idade apresentada deve corresponder à idade completa do animal considerando a data de nascimento.',
    'A idade pode ser apresentada com um ano a mais antes do aniversário.',
    'Média',
    'Média',
    'Aberto'
),


(
    'Login não utiliza armazenamento seguro de senha',
    'Login',
    'Equipe de testes',
    'Manutenção VetCare',
    'A autenticação do sistema realiza comparação de senha em texto puro, sem utilizar mecanismos apropriados de hash e verificação segura de senha. O armazenamento e a comparação de credenciais dessa forma representam um risco de segurança.',
    '1. Acesse os arquivos do sistema VetCare.\n2. Verifique o código responsável pela autenticação.\n3. Analise como as senhas dos usuários são armazenadas no banco de dados.\n4. Verifique como a senha informada no login é comparada.',
    'As senhas devem ser armazenadas utilizando hash seguro e verificadas por mecanismo apropriado de autenticação.',
    'As senhas são armazenadas e comparadas em texto puro.',
    'Alta',
    'Alta',
    'Aberto'
),


(
    'Sessão de login não é regenerada após autenticação',
    'Login',
    'Equipe de testes',
    'Manutenção VetCare',
    'Após autenticação, o sistema não realiza a regeneração do identificador de sessão. Essa ausência pode permitir riscos relacionados à fixação de sessão (Session Fixation).',
    '1. Acesse os arquivos do sistema VetCare.\n2. Analise o código de autenticação.\n3. Verifique o comportamento da sessão após um login bem-sucedido.\n4. Confira se o identificador de sessão é regenerado após autenticar.',
    'O identificador de sessão deve ser regenerado após autenticação bem-sucedida.',
    'Não foi identificada a regeneração do identificador de sessão após o login.',
    'Alta',
    'Alta',
    'Aberto'
),


(
    'Mensagens de login permitem identificar usuário existente',
    'Login',
    'Equipe de testes',
    'Manutenção VetCare',
    'O sistema utiliza mensagens de erro diferentes para situações de usuário inexistente e senha incorreta. Essa diferenciação pode permitir que terceiros identifiquem contas cadastradas.',
    '1. Acesse a tela de login do VetCare.\n2. Informe um usuário inexistente e uma senha.\n3. Tente realizar o login.\n4. Anote a mensagem apresentada.\n5. Repita utilizando um usuário existente e uma senha incorreta.\n6. Compare as mensagens exibidas.',
    'O sistema deve apresentar uma mensagem genérica para falhas de autenticação, sem revelar se o usuário existe.',
    'As mensagens de erro podem diferenciar usuário inexistente de senha incorreta.',
    'Média',
    'Média',
    'Aberto'
);