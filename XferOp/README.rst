XferOp
===========

Simplified Interface for file transfer between landing zone and the cluster.
(Simplify for the most common configurations). Store as modules for other configurations.  


Here are some examples

Default Imports:
1. To preview a file before importing

XferOp.ImportFrom().Preview('/var/lib/HPCCSystems/mydropzone/Test.csv');


2. To import a csv file from drop zone to HPCC

XferOp.ImportFrom().CSVFile('/var/lib/HPCCSystems/mydropzone/Test.csv','myloc::test');

XferOp.ImportFrom().CSVFile('/var/lib/HPCCSystems/mydropzone/Test.csv','myloc::test','|'); // | is the field separator


3. To import a fixed width file from drop zone to HPCC

XferOp.ImportFrom().FixedWidth('/var/lib/HPCCSystems/mydropzone/Test.txt','myloc::test1',1024);// 1024 is the file width


4. To import a XML file from drop zone to HPCC

XferOp.ImportFrom().XMLFile('/var/lib/HPCCSystems/mydropzone/Test.xml','myloc::test2','rowtag');


Default Exports:
1. To export a logical file from HPCC to the drop zone
XferOp.ExportTo().StitchedFile('myloc::test','/var/lib/HPCCSystems/mydropzone/Test.csv');


If you want to override the default settings, you can implement the configuration interfaces (with just the overriden configs and call the function). 
Here is an example. You can create different modules for different configurations and re-use as required:

IMPORT Bundles.XferOp;

Config1 := MODULE(XferOp.Interfaces.Config)
  EXPORT STRING   LandingZoneIP             := '10.0.0.1';

  EXPORT STRING   ClusterName               := 'Mythor400';    

  EXPORT INTEGER  TimeOut                   := 0;
END;

FileConfig := MODULE(XferOp.Interfaces.CSVFile)
  EXPORT STRING Quote := '\"';
  
  EXPORT BOOLEAN OverWriteIfExists := TRUE;
END;

XferOp.ImportFrom(Config1).CSVFile('/var/lib/HPCCSystems/mydropzone/Test.csv','myloc::test',,FileConfig);

