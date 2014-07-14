XferOp
===========

Simplified Interface for file transfer between landing zone and the cluster.
(Simplify for the most common configurations). Store as modules for other configurations.  


Here are some examples
This expects the drop zone to be in this location
/var/lib/HPCCSystems/mydropzone/
The file names are case sensitive.

Default Imports:
1. To preview a file before importing. 

XferOp.ImportFrom().PreviewText('Test.csv');

2. To preview  a file as a table

XFerOp.ImportFrom().PreviewTable('Test.csv',sep :='|'); // Accepts an optional second parameter seperator which is defaulted to comma/

2. To import a csv file from drop zone to HPCC

XferOp.ImportFrom().CSVFile('Test.csv','myloc::test');

XferOp.ImportFrom().CSVFile('Test.csv','myloc::test','|'); // | is the field separator


3. To import a fixed width file from drop zone to HPCC

XferOp.ImportFrom().FixedWidth('Test.txt','myloc::test1',1024);// 1024 is the file width


4. To import a XML file from drop zone to HPCC

XferOp.ImportFrom().XMLFile('Test.xml','myloc::test2','rowtag');


Default Exports:
1. To export a logical file from HPCC to the drop zone
XferOp.ExportTo().StitchedFile('myloc::test','Test.csv');


If you want to override the default settings, you can implement the configuration interfaces (with just the overriden configs and call the function). 
Here is an example. You can create different modules for different configurations and re-use as required:

IMPORT Bundles.XferOp;

Config1 := MODULE(XferOp.Interfaces.Config)
  EXPORT STRING   LandingZoneIP             := '10.0.0.1';
  
  EXPORT STRING   LandingZonePath           := '/var/lib/HPCCSystems/AnotherDropZone/';
  
  EXPORT STRING   ClusterName               := 'Mythor400';    

  EXPORT INTEGER  TimeOut                   := 0;
END;

FileConfig := MODULE(XferOp.Interfaces.CSVFile)
  EXPORT STRING Quote := '\"';
  
  EXPORT BOOLEAN OverWriteIfExists := TRUE;
END;

XferOp.ImportFrom(Config1).CSVFile('Test.csv','myloc::test',,FileConfig);

