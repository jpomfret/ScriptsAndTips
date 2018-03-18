SELECT
	schema_name(obj.SCHEMA_ID) as SchemaName,
	obj.name as TableName, 
	ind.name as IndexName,
	ind.type_desc as IndexType, 
	pas.row_count as Rows, 
	(pas.used_page_count * 8)/1024 as SizeUsedMB, 
	par.data_compression_desc as DataCompression, 
	(pas.reserved_page_count * 8)/1024 as SizeReservedMB
FROM sys.objects obj
INNER JOIN sys.indexes ind
	on obj.object_id = ind.object_id
INNER JOIN sys.partitions par
	on par.index_id = ind.index_id
	and par.object_id = obj.object_id
INNER JOIN sys.dm_db_partition_stats pas
	on pas.partition_id = par.partition_id
WHERE obj.schema_id <> 4 
	--AND schema_name(obj.schema_id) = 'schemaName'
	--AND obj.name = 'tableName'
ORDER BY SizeUsedMB desc
