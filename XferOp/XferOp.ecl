IMPORT STD;

EXPORT XferOp := MODULE
  EXPORT Interfaces := MODULE
    EXPORT Config     := INTERFACE
      EXPORT STRING   LandingZoneIP             := Std.Str.SplitWords(Std.System.Thorlib.DaliServer(),':')[1];
      EXPORT STRING   ClusterName               := STD.System.Thorlib.Group();    
      EXPORT INTEGER  TimeOut                   := -1;
      EXPORT INTEGER  MaxConnections            := 1;
    END;

    SHARED File       := INTERFACE
      EXPORT BOOLEAN OverWriteIfExists := FALSE;
      EXPORT BOOLEAN ReplicateFile     := FALSE;
      EXPORT BOOLEAN Compress          := TRUE;
    END;

    EXPORT CSVFile    := INTERFACE(File)
      EXPORT INTEGER  MaxRecordSize     := 8192;
      EXPORT STRING   LineSeparator     := '\\n,\\r\\n';
      EXPORT STRING   Quote             := '"';
    END;

    EXPORT FixedWidth := INTERFACE(File)
    END;

    EXPORT XMLFile    := INTERFACE(File)
      EXPORT INTEGER  MaxRecordSize     := 8192;
      EXPORT STRING   SrcEncoding       := 'utf8';
    END;
    
    EXPORT StitchedFile := INTERFACE
      EXPORT BOOLEAN OverWriteIfExists  := FALSE;
    END;  
  END;

  SHARED DefaultValues := MODULE
    EXPORT Config     := MODULE(Interfaces.Config)
    END;

    EXPORT CSVFile    := MODULE(Interfaces.CSVFile)
    END;

    EXPORT FixedWidth := MODULE(Interfaces.FixedWidth)
    END;

    EXPORT XMLFile    := MODULE(Interfaces.XMLFile)
    END;
    
    EXPORT StitchedFile := MODULE(Interfaces.StitchedFile)
    END;
  END;

  EXPORT ImportFrom(Interfaces.Config ImportConfig = DefaultValues.Config) := MODULE
    EXPORT CSVFile(STRING SourceFilePath,STRING DestinationFilePath, STRING FieldSeperator = '\\,', Interfaces.CSVFile FileConfig = DefaultValues.CSVFile) := FUNCTION
      RETURN STD.File.SprayVariable(ImportConfig.LandingZoneIP,       // file landing zone
                                    SourceFilePath,                  // path to file on landing zone
                                    FileConfig.MaxRecordSize,        // maximum record size
                                    FieldSeperator,                  // field separator(s)
                                    FileConfig.LineSeparator,        // line separator(s)
                                    FileConfig.Quote,                // text quote character
                                    ImportConfig.ClusterName,       // destination THOR cluster
                                    DestinationFilePath,            // destination file
                                    ImportConfig.TimeOut,            // -1 means no timeout
                                      ,                               // use default ESP server IP port
                                     ImportConfig.MaxConnections ,  // use default maximum connections
                                    FileConfig.OverWriteIfExists,    // allow overwrite
                                    FileConfig.ReplicateFile,        // replicate
                                    FileConfig.Compress              // do not compress
                                    );
    END;

    EXPORT FixedWidth(STRING SourceFilePath,STRING DestinationFilePath, INTEGER RecordSize, Interfaces.FixedWidth FileConfig = DefaultValues.FixedWidth) := FUNCTION
      RETURN STD.File.SprayFixed(ImportConfig.LandingZoneIP,         // file landing zone
                                  SourceFilePath,                  // path to file on landing zone
                                  RecordSize,                      // record size
                                  ImportConfig.ClusterName,       // destination THOR cluster
                                  DestinationFilePath,            // destination file
                                  ImportConfig.TimeOut,            // -1 means no timeout
                                    ,                               // use default ESP server IP port
                                   ImportConfig.MaxConnections ,  // use default maximum connections
                                  FileConfig.OverWriteIfExists,    // allow overwrite
                                  FileConfig.ReplicateFile,        // replicate
                                  FileConfig.Compress              // do not compress
                                  );
    END;

    EXPORT XMLFile(STRING SourceFilePath,STRING DestinationFilePath, STRING RowTag, Interfaces.XMLFile FileConfig = DefaultValues.XMLFile) := FUNCTION
      RETURN STD.File.SprayXML(ImportConfig.LandingZoneIP,       // file landing zone
                                SourceFilePath,                  // path to file on landing zone
                                FileConfig.MaxRecordSize,        // maximum record size
                                RowTag,                         // row delimiting XML tag
                                FileConfig.SrcEncoding,         // Encoding of the file  
                                ImportConfig.ClusterName,       // destination THOR cluster
                                DestinationFilePath,            // destination file
                                ImportConfig.TimeOut,            // -1 means no timeout
                                  ,                               // use default ESP server IP port
                                 ImportConfig.MaxConnections ,  // use default maximum connections
                                FileConfig.OverWriteIfExists,    // allow overwrite
                                FileConfig.ReplicateFile,        // replicate
                                FileConfig.Compress              // do not compress
                                );
    END;
  END;

  EXPORT ExportTo(Interfaces.Config ExportConfig = DefaultValues.Config) := MODULE
    EXPORT StitchedFile(STRING SourceFilePath,STRING DestinationFilePath,Interfaces.StitchedFile FileConfig = DefaultValues.StitchedFile) := FUNCTION
      RETURN STD.File.Despray(SourceFilePath,                 // Fully scoped source file
                              ExportConfig.LandingZoneIP,     // file landing zone
                              DestinationFilePath,            // path to file on landing zone
                              ExportConfig.TimeOut,            // -1 means no timeout
                               ,                               // use default ESP server IP port
                              ExportConfig.MaxConnections ,    // use default maximum connections
                              FileConfig.OverWriteIfExists    // allow overwrite
                              );
    END;
  END; 
END;