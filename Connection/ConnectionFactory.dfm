object ConnFactory: TConnFactory
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 139
  Width = 161
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    LoginPrompt = False
    Transaction = Trans
    Left = 24
    Top = 16
  end
  object Trans: TFDTransaction
    Options.AutoStop = False
    Connection = Conn
    Left = 104
    Top = 16
  end
  object QuerySQL: TFDQuery
    Connection = Conn
    Transaction = Trans
    Left = 24
    Top = 80
  end
  object QueryTable: TFDQuery
    Connection = Conn
    Transaction = Trans
    FetchOptions.AssignedValues = [evRowsetSize, evRecordCountMode]
    FetchOptions.RowsetSize = 200
    SQL.Strings = (
      'SELECT'
      '  RF.RDB$FIELD_NAME FIELD_NAME,'
      '  CASE F.RDB$FIELD_TYPE'
      '    WHEN 7 THEN'
      '      CASE F.RDB$FIELD_SUB_TYPE'
      '        WHEN 0 THEN '#39'SMALLINT'#39
      
        '        WHEN 1 THEN '#39'NUMERIC('#39' || F.RDB$FIELD_PRECISION || '#39', '#39' ' +
        '|| (-F.RDB$FIELD_SCALE) || '#39')'#39
      '        WHEN 2 THEN '#39'DECIMAL'#39
      '      END'
      '    WHEN 8 THEN'
      '      CASE F.RDB$FIELD_SUB_TYPE'
      '        WHEN 0 THEN '#39'INTEGER'#39
      
        '        WHEN 1 THEN '#39'NUMERIC('#39'  || F.RDB$FIELD_PRECISION || '#39', '#39 +
        ' || (-F.RDB$FIELD_SCALE) || '#39')'#39
      '        WHEN 2 THEN '#39'DECIMAL'#39
      '      END'
      '    WHEN 9 THEN '#39'QUAD'#39
      '    WHEN 10 THEN '#39'FLOAT'#39
      '    WHEN 12 THEN '#39'DATE'#39
      '    WHEN 13 THEN '#39'TIME'#39
      
        '    WHEN 14 THEN '#39'CHAR('#39' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$B' +
        'YTES_PER_CHARACTER)) || '#39') '#39
      '    WHEN 16 THEN'
      '      CASE F.RDB$FIELD_SUB_TYPE'
      '        WHEN 0 THEN '#39'BIGINT'#39
      
        '        WHEN 1 THEN '#39'NUMERIC('#39' || F.RDB$FIELD_PRECISION || '#39', '#39' ' +
        '|| (-F.RDB$FIELD_SCALE) || '#39')'#39
      '        WHEN 2 THEN '#39'DECIMAL'#39
      '      END'
      '    WHEN 27 THEN '#39'DOUBLE'#39
      '    WHEN 35 THEN '#39'TIMESTAMP'#39
      
        '    WHEN 37 THEN '#39'VARCHAR('#39' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RD' +
        'B$BYTES_PER_CHARACTER)) || '#39')'#39
      
        '    WHEN 40 THEN '#39'CSTRING'#39' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB' +
        '$BYTES_PER_CHARACTER)) || '#39')'#39
      '    WHEN 45 THEN '#39'BLOB_ID'#39
      '    WHEN 261 THEN '#39'BLOB SUB_TYPE '#39' || F.RDB$FIELD_SUB_TYPE'
      '    ELSE '#39'RDB$FIELD_TYPE: '#39' || F.RDB$FIELD_TYPE || '#39'?'#39
      '  END FIELD_TYPE,'
      '  F.RDB$FIELD_TYPE FIELD_NUMBER, RF.RDB$NULL_FLAG FIELD_NULL'
      'FROM RDB$RELATION_FIELDS RF'
      'JOIN RDB$FIELDS F ON (F.RDB$FIELD_NAME = RF.RDB$FIELD_SOURCE)'
      
        'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_I' +
        'D = F.RDB$CHARACTER_SET_ID)'
      
        'LEFT OUTER JOIN RDB$COLLATIONS DCO ON ((DCO.RDB$COLLATION_ID = F' +
        '.RDB$COLLATION_ID) AND (DCO.RDB$CHARACTER_SET_ID = F.RDB$CHARACT' +
        'ER_SET_ID))'
      
        'WHERE (RF.RDB$RELATION_NAME = :TABLE_NAME) AND (COALESCE(RF.RDB$' +
        'SYSTEM_FLAG, 0) = 0)'
      'ORDER BY RF.RDB$FIELD_POSITION;')
    Left = 104
    Top = 80
    ParamData = <
      item
        Name = 'TABLE_NAME'
        DataType = ftWideString
        ParamType = ptInput
        Size = 15
        Value = ''
      end>
  end
end
