DECLARE @Text varchar(8000), @filename varchar(300)
Declare book cursor read_only
for
Select  table_name, REplace('<?php
Class '+ table_name  +' {
	private $db;

	public function __construct($connection)
	{
		$this->db= $connection;
	}

    public function getList($data=array())
    {
        $result =array();
        try{
            $sql ="Select '+Table_Name+'.*, '+Table_Name+'.'+ column_name+' as id'+ ISNULL(', '+ REplace(REplace(REplace((
					SELECT  
					 distinct (Select top 1 TABLE_NAME+'.'+Column_name from Information_schema.columns where table_name=KCU2.TABLE_NAME and ORDINAL_POSITION>1 order by ORDINAL_POSITION)
					   as t
					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC 

				INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU1 
					ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  
					AND KCU1.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA 
					AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME 

				INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU2 
					ON KCU2.CONSTRAINT_CATALOG = RC.UNIQUE_CONSTRAINT_CATALOG  
					AND KCU2.CONSTRAINT_SCHEMA = RC.UNIQUE_CONSTRAINT_SCHEMA 
					AND KCU2.CONSTRAINT_NAME = RC.UNIQUE_CONSTRAINT_NAME 
					AND KCU2.ORDINAL_POSITION = KCU1.ORDINAL_POSITION 
					 where KCU1.TABLE_NAME = C.TABLE_NAME For xml path('')),'</t><t>',','),'</t>',''),'<t>',''),'')+ ' from '+ Table_Name + 
				ISNULL(REplace(REplace(REplace((
					SELECT  
					 distinct ' left join '+KCU2.TABLE_NAME + ' on '+ KCU1.TABLE_NAME+'.'+KCU1.COLUMN_NAME + ' = ' + KCU2.TABLE_NAME+'.'+KCU2.COLUMN_NAME +' '  as t
					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC 

				INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU1 
					ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  
					AND KCU1.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA 
					AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME 

				INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU2 
					ON KCU2.CONSTRAINT_CATALOG = RC.UNIQUE_CONSTRAINT_CATALOG  
					AND KCU2.CONSTRAINT_SCHEMA = RC.UNIQUE_CONSTRAINT_SCHEMA 
					AND KCU2.CONSTRAINT_NAME = RC.UNIQUE_CONSTRAINT_NAME 
					AND KCU2.ORDINAL_POSITION = KCU1.ORDINAL_POSITION 
					 where KCU1.TABLE_NAME = c.TABLE_NAME for xml path('')),'</t><t>',''),'</t>',''),'<t>',''),'') +'";
            
			if(count($data)>0)
            {
                $arr =array();
                foreach ($data as $key => $value) {
                    $arr[] = " $key =''$value'' ";
                }    
                $sql .= " where ". implode(" and ", $arr);
            }
			$db = $this->db;
            $stmt = $db->prepare($sql);
            $stmt->execute();
            $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
            $db = null;
        }
        catch(PDOException $e) {
        }
        
        return $result;
    }

    public function all($data=array())
    {
        //Return Variable Array
        $result =array();
        try{
            //Get all Data
            $data = $this->getList();
            //Return Variable Assignment (Success)
            $result = array("status"=> 0, "message"=> "Records Retrieved", "data"=>$data); 
            $db = null; //De-assigned Database Variable
        }
        catch(PDOException $e) {
            //Return Variable Assignment (Error)
            $result = array("status"=> 100, "message"=> $e->getMessage());
            //Logger    
        }
        return $result;

    }
    
    public function add($data)
    {
        $result =array();
        try{
            $UserID =0;
            //Insert Query
            $sql ="' +'Insert into '+ Table_name +'(' +Replace(Replace(Replace((Select COLUMN_NAME as t from INFORMATION_SCHEMA.COLUMNS where Table_name
 = c.table_name and column_name not in ('ModifiedBy','DateModified') and ORDINAL_POSITION <>1
 For xml path('')),'</t><t>',','),'<t>',''),'</t>','') +') Values('+Replace(Replace(Replace((Select case column_name when 'DateCreated' then 'getdate()' else '?' end as t from INFORMATION_SCHEMA.COLUMNS where Table_name
 = c.table_name and column_name not in ('ModifiedBy','DateModified') and ORDINAL_POSITION <>1
 For xml path('')),'</t><t>',','),'<t>',''),'</t>','') +')";
            $db = $this->db;
            $stmt = $db->prepare($sql);
            //Parameter Placeholder Assigment
            $stmt->execute(['+Replace(Replace(Replace((Select case when column_name  in ('CreatedBy','ModifiedBy')  then '$UserID' else '@$data->'+COLUMN_NAME end as t from INFORMATION_SCHEMA.COLUMNS where Table_name
 = c.table_name and column_name not in ('ModifiedBy','DateModified','DateCreated') and ORDINAL_POSITION <>1
 For xml path('')),'</t><t>',','),'<t>',''),'</t>','')+']);
            //Get Updated Records
            $data = $this->getList();
            $result = array("status"=> 0, "message"=> "Record Successfully Created", "data"=>$data); 

            $db = null;
        }
        catch(PDOException $e) {
            $result = array("status"=> 100, "message"=> $e->getMessage());
            //Logger    
        }
        
        return $result;
    }
    
    public function update($data)
    {
        $result =array();
        try{
            $UserID =0;
            //Insert Query
            $sql ="'+'Update '+ Table_name +' Set '+Replace(Replace(Replace((Select COLUMN_NAME + case column_name when 'DateModified' then '=getdate()' else '=?' end as t from INFORMATION_SCHEMA.COLUMNS where Table_name
 = c.TABLE_NAME and column_name not in ('CreatedBy','DateCreated') and ORDINAL_POSITION <>1
 For xml path('')),'</t><t>',','),'<t>',''),'</t>','') + ' Where '+ column_name +'=?";
            $db = $this->db;
            $stmt = $db->prepare($sql);
            //Parameter Placeholder Assigment
            $stmt->execute(['+Replace(Replace(Replace((Select case when column_name  in ('CreatedBy','ModifiedBy')  then '$UserID' else '@$data->'+COLUMN_NAME end as t from INFORMATION_SCHEMA.COLUMNS where Table_name
 = c.table_name and column_name not in ('CreatedBy','DateModified','DateCreated') and ORDINAL_POSITION <>1
 For xml path('')),'</t><t>',','),'<t>',''),'</t>','')+',$data->'+c.COLUMN_NAME+']);
            //Get Updated Records
            $data = $this->getList();
            $result = array("status"=> 0, "message"=> "Record Successfully Updated", "data"=>$data); 

            $db = null;
        }
        catch(PDOException $e) {
            $result = array("status"=> 100, "message"=> $e->getMessage());
            //Logger    
        }  
        return $result;
    }
    
    public function get($id)
    {
        //Return Variable Array
        $result =array();
        try{
            $sql ="Select * from '+ Table_Name+' where '+ COLUMN_NAME+'=?";
            $db = $this->db;
            $stmt = $db->prepare($sql);
            $stmt->execute([$id]);
            $data = $stmt->fetch(PDO::FETCH_ASSOC);
            //Return Variable Assignment (Success)
            $result = array("status"=> 0, "message"=> "Records Retrieved", "data"=>$data); 
            $db = null; //De-assigned Database Variable
        }
        catch(PDOException $e) {
            //Return Variable Assignment (Error)
            $result = array("status"=> 100, "message"=> $e->getMessage());
            //Logger    
        }
        return $result;
    }
}', '&gt;','>') codes
 from INFORMATION_SCHEMA.COLUMNS c 
 where ORDINAL_POSITION =1 and TABLE_NAME !='sysdiagrams'
 --and TABLE_NAME ='CriteriaIndicator'
 ;

Open book;

FETCH next from book into @filename, @Text;

While @@FETCH_STATUS = 0
BEGIN
	DECLARE @File  varchar(300) = 'c:\fi\'+@filename+'.php'
	DECLARE @OLE INT 
	DECLARE @FileID INT

	EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT 
	EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @File, 2, 1 
	--EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @File, 8, 1 --Appending
	EXECUTE sp_OAMethod @FileID, 'WriteLine', Null, @Text
	EXECUTE sp_OADestroy @FileID 
	EXECUTE sp_OADestroy @OLE 

	FETCH next from book into @filename, @Text;
END

Close book;
Deallocate book;
--exec master..sp_configure 'Ole Automation Procedures',1
--RECONFIGURE

