IMPORT STD;
  
EXPORT XferOp := MODULE
  EXPORT Bundle := MODULE(Std.BundleBase)
    EXPORT Name       := 'XferOp';
    EXPORT Description     := 'Simplifying file transfer operations to and from landing zone.';
    EXPORT Authors       := ['Omnibuzz'];
    EXPORT License       := 'http://www.apache.org/licenses/LICENSE-2.0';
    EXPORT Copyright     := 'Use, Improve, Extend, Distribute';
    EXPORT DependsOn     := [];
    EXPORT Version       := '1.0.1';
  END; 
  
  EXPORT Interfaces := MODULE
    EXPORT Config     := INTERFACE
      EXPORT STRING   LandingZoneIP             := Std.Str.SplitWords(Std.System.Thorlib.DaliServer(),':')[1];
      EXPORT STRING   LandingZonePath           := '/var/lib/HPCCSystems/mydropzone/';
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
      EXPORT STRING   LineSeparator			:= '\\n,\\r\\n,\\r,\\n\\r';
      EXPORT STRING   Quote							:= '';
    END;

    EXPORT FixedWidth := INTERFACE(File)
    END;

    EXPORT XMLFile    := INTERFACE(File)
      EXPORT INTEGER  MaxRecordSize     := 8192;
      EXPORT STRING   SrcEncoding       := 'utf8';
    END;
    
    EXPORT StitchedFile := INTERFACE
      EXPORT BOOLEAN OverWriteIfExists := FALSE;
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
    EXPORT PreviewText(STRING SourceFile) := FUNCTION
      RETURN DATASET(STD.File.ExternalLogicalFileName(ImportConfig.LandingZoneIP,		 	    // file landing zone
                                                ImportConfig.LandingZonePath + SourceFile	// path to file on landing zone
                                                ),
                                                {STRING records},
                                                CSV(SEPARATOR(''),
                                                TERMINATOR(['\n','\r\n','\n\r','\r'])));
    END;
    
    SHARED GenericTableLayout := RECORD
      STRING Col1; 
      STRING Col2;
      STRING Col3;
      STRING Col4;
      STRING Col5;
      STRING Col6;
      STRING Col7;
      STRING Col8;
      STRING Col9;
      STRING Col10;
      STRING Col11;
      STRING Col12;
      STRING Col13;
      STRING Col14;
      STRING Col15;
      STRING Col16;
      STRING Col17;
      STRING Col18;
      STRING Col19;
      STRING Col20;
      STRING Col21;
      STRING Col22;
      STRING Col23;
      STRING Col24;
      STRING Col25;
      STRING Col26;
      STRING Col27;
      STRING Col28;
      STRING Col29;
      STRING Col30;
      STRING Col31;
      STRING Col32;
      STRING Col33;
      STRING Col34;
      STRING Col35;
      STRING Col36;
      STRING Col37;
      STRING Col38;
      STRING Col39;
      STRING Col40;
      STRING Col41;
      STRING Col42;
      STRING Col43;
      STRING Col44;
      STRING Col45;
      STRING Col46;
      STRING Col47;
      STRING Col48;
      STRING Col49;
      STRING Col50;
      STRING Col51;
      STRING Col52;
      STRING Col53;
      STRING Col54;
      STRING Col55;
      STRING Col56;
      STRING Col57;
      STRING Col58;
      STRING Col59;
      STRING Col60;
      STRING Col61;
      STRING Col62;
      STRING Col63;
      STRING Col64;
      STRING Col65;
      STRING Col66;
      STRING Col67;
      STRING Col68;
      STRING Col69;
      STRING Col70;
      STRING Col71;
      STRING Col72;
      STRING Col73;
      STRING Col74;
      STRING Col75;
      STRING Col76;
      STRING Col77;
      STRING Col78;
      STRING Col79;
      STRING Col80;
      STRING Col81;
      STRING Col82;
      STRING Col83;
      STRING Col84;
      STRING Col85;
      STRING Col86;
      STRING Col87;
      STRING Col88;
      STRING Col89;
      STRING Col90;
      STRING Col91;
      STRING Col92;
      STRING Col93;
      STRING Col94;
      STRING Col95;
      STRING Col96;
      STRING Col97;
      STRING Col98;
      STRING Col99;
      STRING Col100;
    END;
  
    EXPORT PreviewTable(STRING SourceFile,STRING1 Sep = ',') := FUNCTION
      RETURN DATASET(STD.File.ExternalLogicalFileName(ImportConfig.LandingZoneIP,		 	    // file landing zone
                                                ImportConfig.LandingZonePath + SourceFile	// path to file on landing zone
                                                ),
                                                GenericTableLayout,
                                                CSV(SEPARATOR(Sep),
                                                TERMINATOR(['\n','\r\n','\n\r','\r'])));
    END;
    
    
    EXPORT CSVFile(STRING SourceFile,STRING DestinationFilePath, STRING FieldSeperator = '\\,', Interfaces.CSVFile FileConfig = DefaultValues.CSVFile) := FUNCTION
      RETURN STD.File.SprayVariable(ImportConfig.LandingZoneIP,		 	// file landing zone
                                    ImportConfig.LandingZonePath + SourceFile,	// path to file on landing zone
                                    FileConfig.MaxRecordSize,				// maximum record size
                                    FieldSeperator,	                // field separator(s)
                                    FileConfig.LineSeparator,		    // line separator(s)
                                    FileConfig.Quote,						    // text quote character
                                    ImportConfig.ClusterName,       // destination THOR cluster
                                    DestinationFilePath,						// destination file
                                    ImportConfig.TimeOut,						// -1 means no timeout
                                      ,													 		// use default ESP server IP port
                                    ImportConfig.MaxConnections ,	// use default maximum connections
                                    FileConfig.OverWriteIfExists,		// allow overwrite
                                    FileConfig.ReplicateFile,				// replicate
                                    FileConfig.Compress							// do not compress
                                    );
    END;

    EXPORT FixedWidth(STRING SourceFile,STRING DestinationFilePath, INTEGER RecordSize, Interfaces.FixedWidth FileConfig = DefaultValues.FixedWidth) := FUNCTION
      RETURN STD.File.SprayFixed(ImportConfig.LandingZoneIP,		 	  // file landing zone
                                  ImportConfig.LandingZonePath + SourceFile, // path to file on landing zone
                                  RecordSize,				              // record size
                                  ImportConfig.ClusterName,       // destination THOR cluster
                                  DestinationFilePath,						// destination file
                                  ImportConfig.TimeOut,						// -1 means no timeout
                                    ,													 		// use default ESP server IP port
                                  ImportConfig.MaxConnections ,	// use default maximum connections
                                  FileConfig.OverWriteIfExists,		// allow overwrite
                                  FileConfig.ReplicateFile,				// replicate
                                  FileConfig.Compress							// do not compress
                                  );
    END;

    EXPORT XMLFile(STRING SourceFile,STRING DestinationFilePath, STRING RowTag, Interfaces.XMLFile FileConfig = DefaultValues.XMLFile) := FUNCTION
      RETURN STD.File.SprayXML(ImportConfig.LandingZoneIP,		 	// file landing zone
                                ImportConfig.LandingZonePath + SourceFile, // path to file on landing zone
                                FileConfig.MaxRecordSize,				// maximum record size
                                RowTag,                         // row delimiting XML tag
                                FileConfig.SrcEncoding,         // Encoding of the file  
                                ImportConfig.ClusterName,       // destination THOR cluster
                                DestinationFilePath,						// destination file
                                ImportConfig.TimeOut,						// -1 means no timeout
                                  ,													 		// use default ESP server IP port
                                ImportConfig.MaxConnections ,	// use default maximum connections
                                FileConfig.OverWriteIfExists,		// allow overwrite
                                FileConfig.ReplicateFile,				// replicate
                                FileConfig.Compress							// do not compress
                                );
    END;
  END;

  EXPORT ExportTo(Interfaces.Config ExportConfig = DefaultValues.Config) := MODULE
    EXPORT StitchedFile(STRING SourceFilePath,STRING DestinationFile,Interfaces.StitchedFile FileConfig = DefaultValues.StitchedFile) := FUNCTION
      RETURN STD.File.Despray(SourceFilePath,                 // Fully scoped source file
                              ExportConfig.LandingZoneIP,     // file landing zone
                              ExportConfig.LandingZonePath + DestinationFile, // path to file on landing zone
                              ExportConfig.TimeOut,						// -1 means no timeout
                               ,													 		// use default ESP server IP port
                              ExportConfig.MaxConnections ,	  // use default maximum connections
                              FileConfig.OverWriteIfExists		// allow overwrite
                              );
    END;
  END; 
END;
