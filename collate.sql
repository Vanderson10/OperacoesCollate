/*analisar o collate dos bancos*/
SELECT name, collation_name from sys.databases

/*verificar qual collation o banco geral está usando*/
use Nome_banco
go 
select name, collation_name from sys.databases where name = 'Nome_banco';


/*alterar collate do banco todo*/
ALTER DATABASE Nome_banco  SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO 
ALTER DATABASE Nome_banco  COLLATE SQL_Latin1_General_CP1_CI_AI;
GO 
ALTER DATABASE Nome_banco  SET MULTI_USER; 

/*verificar os collates de cada coluna c.is_nullable = 0 para colunas NOT NULL e = 1...*/
SELECT c.name as 'coluna', t.name as 'tabela', c.collation_name
from sys.columns as c 
inner join sys.tables as t on c.object_id  = t.object_id 
where collation_name  is not null c.is_nullable = 0
and t.type = 'U'
ORDER BY 2;
GO

/*Geração dos scripts*/
select --c.name as ‘coluna’, t.name as ‘tabela’, c.collation_name, ty.name as ‘tipo_coluna’, c.max_length as ‘tamanho’  
'ALTER TABLE ' + t.name + ' ALTER COLUMN ' + c.name + ' ' + ty.name + '(' + CONVERT(VARCHAR, c.max_length) + ') COLLATE SQL_Latin1_General_CP1_CI_AI NULL'  
from sys.columns as c
inner join sys.tables as t on c.object_id = t.object_id
inner join sys.types as ty on ty.system_type_id = c.system_type_id
where c.collation_name is not null
and t.type = 'U';
GO

